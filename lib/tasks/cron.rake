namespace :messages do
	desc "Find, and remove old/expired messages."
	task :expire => :environment do
		begin
			m = Message.scoped(:conditions => ['expires_at <= ?', DateTime.now])
			
			Rails.logger.info "#{Time.now}: Expiring #{m.size} messages!" if m.many?
			
			m.destroy_all
		rescue Exception => e
			Rails.logger.error "#{Time.now}: #{e}"
		end
	end
end