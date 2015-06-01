class MessagesCleanupJob < ActiveJob::Base
  include SuckerPunch::Job
  queue_as :default

  def perform(*args)
    ActiveRecord::Base.connection_pool.with_connection do
      c = Message.destroy_all ['expires_at <= ?', DateTime.now]
      Rails.logger.info "Removed #{c.count} messages."
    end
  end
end
