# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser(versions: :modern)

  rescue_from(ActiveRecord::RecordNotFound, with: :handle_record_not_found)

  private

  def handle_record_not_found
    flash[:alert] = t("controllers.application.flash.alert")

    redirect_to(root_path)
  end
end
