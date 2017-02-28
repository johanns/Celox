class MessagesController < ApplicationController
  include ::ApiErrorHandlers

  def show
    ms = MessagesService.new(params)
    @data = ms.retrieve
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def new
    @message = Message.new
  end

  def create
    ms = MessagesService.new(params)
    key = ms.store

    render json: { data: key }, status: :ok
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
