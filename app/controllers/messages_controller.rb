class MessagesController < ApplicationController
  # GET /stub
  def show_by_stub
    @message = Message.find_by_stub(Message.hash_key(params[:stub]))

    unless @message.nil?
      @decrypted_body = Message.retreive_message(params[:stub], @message, request.remote_ip)
      
      respond_to do |format|
        format.html
        format.json { render json: @decrypted_body.to_json }
      end
    else
      respond_to do |format|
        format.html { render action: "not_found", notice: "Message not found!" }
        format.json { render json: '3r3', status: :unprocessable_entity }
      end
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message.as_json }
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    @key = Message.new_message(@message, request.remote_ip)

    respond_to do |format|
      if @message.save
        key_url = "#{request.protocol + request.host_with_port}/#{@key}"
        
        format.html { render action: "success", notice: "Message was successfully created. Secret: #{key_url}" }
        format.json { render json: key_url.to_json }
        
        if (Rails.env == 'development')
          Rails.logger.info key_url
        end
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
end
