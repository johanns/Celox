namespace :messages do
	desc "Find, and remove expired messages."
	task :expire => :environment do
		begin
			m = Message.scoped(:conditions => ['expires_at <= ?', DateTime.now])
			
			if m.many?
				Rails.logger.unknown "#{Time.now}: Expiring #{m.size} messages!"
			end
		
			m.destroy_all
		rescue Exception => e
			Rails.logger.error "#{Time.now}: #{e}"
		end
	end
end