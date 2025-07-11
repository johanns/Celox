# frozen_string_literal: true

class MessagesController < ApplicationController
  include Challengeable

  before_action(:set_message, only: %i[fetch show])
  before_action(:validate_challenge, only: %i[fetch])

  def show
    # Check if message was already read
    if @message.read?
      @message_read_at = @message.read_at
      @message_body = nil
      return
    end

    setup_challenge_session

    # Don't call read! here anymore - we'll do it in fetch action after captcha
    @message_body = nil
    @message_read_at = nil
  end

  def fetch
    message_body, message_read_at = @message.read!

    render_success_response(body: message_body, read_at: message_read_at)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(processed_message_params)

    if @message.save
      render_created_response
    else
      render_validation_errors
    end
  end

  private

  def set_message
    @message = Message.active.find_by!(stub: params[:stub])
  end

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

  # JSON response helpers
  def render_success_response(body:, read_at:)
    render(json: {
             success: true,
             body: body,
             read_at: read_at
           })
  end

  def render_created_response
    render(json: {
             success: true,
             message: {
               stub: @message.stub,
               retrieval_url: read_message_url(@message.stub)
             }
           },
           status: :created)
  end

  def render_validation_errors
    render(json: {
             success: false,
             errors: @message.errors.to_hash(true)
           },
           status: :unprocessable_entity)
  end
end
