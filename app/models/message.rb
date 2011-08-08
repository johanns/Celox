require 'crypto'

class Message < ActiveRecord::Base
  include Crypto  

  validates_presence_of :body

  
  unless defined? CIPHER
    CIPHER = 'aes-256-cbc'
  end
  
  unless defined? KEY_SIZE
    KEY_SIZE = 8
  end
  
  unless defined? READ_MARKER
    READ_MARKER = '!--READ--!'
  end

  unless defined? TRACK_IP
    TRACK_IP = true
  end

  # Overrode Message (model) to_json via as_json to limit returned fields
  def as_json(options = {})
    # this example ignores the user's options
    super(:only => [:body, :sender_email, :recipient_email, :read_at])
  end

  class << self
    def new_message(m, remote_ip)
      #debugger
      key = Message.generate_key(KEY_SIZE)
      m.body = Message.encrypt(CIPHER, key, m.body)
      m.stub = Message.hash_key(key)
      m.created_at = Time.now

      if TRACK_IP
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
        m.body = READ_MARKER # => body cannot be blank
        
        if TRACK_IP
          m.recipient_ip = remote_ip
        end

        m.save
      else
        body = "Message was read " 

        if TRACK_IP 
          body << "by #{m.recipient_ip}"
        end 

        body << " at #{m.read_at}"
        minutes = ((Time.now - m.read_at.to_time) / 1.minute).round

        if (minutes <= 0)
          body << " (less than a minute ago)"
        else
          body << " (about #{minutes} minute(s) ago)"  
        end
      end

      return body
    end
  end
end
