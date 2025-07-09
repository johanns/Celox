# frozen_string_literal: true

desc 'Cleanup expired messages'
task cleanup_expired_messages: :environment do
  Rails.logger.info 'Starting cleanup of expired messages...'

  deleted_count = CleanupExpiredMessagesJob.perform_now

  Rails.logger.info "Cleanup completed. Deleted #{deleted_count} expired messages."
end
