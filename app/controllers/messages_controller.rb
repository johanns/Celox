class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end
  
  # GET /stub
  def show_by_stub
    @message = Message.find_by_stub(Message.hash_key(params[:stub]))

    unless @message.nil?
      @decrypted_body = Message.retreive_message(params[:stub], @message, request.remote_ip)
      
      respond_to do |format|
        format.html
      end
    else
       render action: "not_found", notice: "Message not found!"
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    @key = Message.new_message(@message, request.remote_ip)

    respond_to do |format|
      if @message.save
        key_url = "#{request.protocol + request.host_with_port}/#{@key}"
        
        format.html { redirect_to @message, notice: "Message was successfully created. 
          Secret: #{key_url}" }
        format.json { render json: @message, status: :created, location: @message }
        
        if (Rails.env == 'development')
          Rails.logger.info key_url
        end
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :ok }
    end
  end
end
