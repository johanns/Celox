namespace :messages do
	desc "Find, and remove expired messages."
	task :expire => :environment do
		m = Message.scoped(:conditions => ['expires_at <= ?', DateTime.now])
		Rails.logger.unknown "#{Time.now}: Expiring #{m.size} messages!"
		m.destroy_all
	end
end