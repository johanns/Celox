# frozen_string_literal: true

class MessagesController < ApplicationController
  def show
    message = Message.active.find_by!(stub: params[:stub])
    @message_body, @message_read_at = message.read!
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(processed_message_params)

    if @message.save
      render(json: {
               success: true,
               message: {
                 stub: @message.stub,
                 retrieval_url: read_message_url(@message.stub)
               }
             },
             status: :created)
    else
      render(json: {
               success: false,
               errors: @message.errors.to_hash(true)
             },
             status: :unprocessable_entity)
    end
  end

  private

  def message_params
    params.expect(message: %i[body expiration_duration])
  end

  def normalize_expiration_duration(value)
    value.present? ? value.to_sym : nil
  end

  def processed_message_params
    message_params.merge(
      expiration_duration: normalize_expiration_duration(message_params[:expiration_duration])
    )
  end
end
