module ApiErrorHandlers
  extend ActiveSupport::Concern
  include ::Rack::Utils

  included do
    rescue_from ActionController::ParameterMissing, with: :parameter_missing_error
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_error
    rescue_from ActiveRecord::RecordNotSaved, with: :record_not_saved_error
  end

  def parameter_missing_error(e)
    handle_error(e.message, status_code(:not_acceptable))
  end

  def record_not_found_error(e)
    handle_error(e.message, status_code(:not_found))
  end

  def record_invalid_error(e)
    handle_error(e.message, status_code(:unprocessable_entity))
  end

  def record_not_saved_error(e)
    handle_error(e.message, status_code(:unprocessable_entity))
  end

  protected

  def handle_error(message, status)
    render json: { error: message }, status: status
  end
end
