class MessagesController < ApplicationController
  before_filter :set_locale
   
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Ref: http://paydrotalks.com/posts/45-standard-json-response-for-rails-and-jquery
  def render_json_response(type, hash)
    unless [ :ok, :redirect, :error ].include?(type)
      raise "Invalid json response type: #{type}"
    end

    # To keep the structure consistent, we'll build the json 
    # structure with the default properties.
    #
    # This will also help other developers understand what 
    # is returned by the server by looking at this method.
    default_json_structure = { 
      :status => type, 
      :html => nil, 
      :message => nil, 
      :to => nil }.merge(hash)

    render_options = {:json => default_json_structure}  
    render_options[:status] = 400 if type == :error

    render(render_options)
  end

  # GET /stub
  # GET /stub.json
  def show_by_stub
    @message = Message.find_by_stub(Message.hash_key(params[:stub]))

    unless @message.nil?
      read, @data = Message.retreive_message(params[:stub], @message, request.remote_ip)
      
      unless read
        respond_to do |format|
          format.html
          format.json { render_json_response :ok, :message => @data }
        end
      else
        respond_to do |format|
          format.html { render action: "was_read", :notice => @data }
          format.json { reneder_json_response :error, :messsage => @data }
        end
      end
    else
      respond_to do |format|
        format.html { render action: "error", notice: t(:message_not_found) }
        format.json { render_json_response :error, :message => t(:message_not_found_json) }
      end
    end
  end

  # GET /n
  # GET /n.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render_json_response :ok, :message => @message }
    end
  end

  # POST /n
  # POST /n.json
  def create
    @message = Message.new(params[:message])
    @key = Message.new_message(@message, request.remote_ip)

    respond_to do |format|
      if @message.save
        @key_url = "#{request.protocol + request.host_with_port}/#{@key}"
        
        format.json { render_json_response :ok, :message => @key_url }
        format.js { render action: "success"}
        
        if (Rails.env == 'development')
          Rails.logger.info @key_url
        end
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
end
