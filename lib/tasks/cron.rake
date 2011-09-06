desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
		m = Message.scoped(:conditions => ['expires_at <= ?', DateTime.now])
		Rails.logger.info "Expiring #{m.size} messages!"
		m.destroy_all
end