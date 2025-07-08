# frozen_string_literal: true

desc 'Cleanup expired messages'
task cleanup_expired_messages: :environment do
  puts 'Starting cleanup of expired messages...'

  deleted_count = CleanupExpiredMessagesJob.perform_now

  puts "Cleanup completed. Deleted #{deleted_count} expired messages."
end
