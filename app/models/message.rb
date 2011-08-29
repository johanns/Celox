# Change the new_message; idea: before_save/create filter.

require 'crypto'

class Message < ActiveRecord::Base
  include Crypto  
  
  validates :body, presence: true

  # Override json response to limit fields returned
  def as_json(options = {})
    # this example ignores the user's options
    super(:only => [:body])
  end

  class << self
    def new_message(m, remote_ip)
      #debugger
      key = Message.generate_key(APP_KEY_LENGTH)
      m.body = Message.encrypt(APP_CIPHER, key, m.body)
      m.stub = Message.hash_key(key)
      m.created_at = Time.now

      if APP_TRACK_IP
        m.sender_ip = remote_ip
      end

      return m.save && key
    end
    
    def retreive_message(key, m, remote_ip)
      #debugger
      read = false
      body = String.new
      
      unless m.read_at
        body = Message.decrypt(key, m.body)
        m.read_at = Time.now
        m.body = APP_READ_MARKER # => body cannot be blank
        
        m.recipient_ip = remote_ip if APP_TRACK_IP

        m.save
      else
        read = true

        if APP_TRACK_IP
          body = I18n.translate(:message_was_read_at_by_ip, read_at: m.read_at, remote_ip: m.recipient_ip)
        else
          body = I18n.translate(:message_was_read_at, read_at: m.read_at)
        end
      end

      return [read, body]
    end
  end
end
