class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :destroy]

  def show
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.js { render :show_key }
      else
        format.html { render :new }
      end
    end
  end

  private
  
  def set_message
    @message = Message.fetch_message(key: params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
