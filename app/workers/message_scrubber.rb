class MessageScrubber	
	def self.perform
		Message.scoped(:conditions => ['expires_at =< ?', DateTime.now]).each { |m| m.destroy }
	end
end