# frozen_string_literal: true

class CleanupExpiredMessagesJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Starting cleanup of expired messages..."

    deleted_count = 0
    Message.expired.find_each do |message|
      message.destroy
      deleted_count += 1
    end

    Rails.logger.info "Cleanup completed. Deleted #{deleted_count} expired messages."
    deleted_count
  end
end
