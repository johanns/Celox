require 'crypto'

class Message < ActiveRecord::Base
  include Crypto  

  validates :body, :presence => { :message => I18n.t(:message_body_not_present) }
  
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

  # Overrode to_json via as_json to limit returned fields on GET
  def as_json(options = {})
    # this example ignores the user's options
    super(:only => [:body, :sender_email, :recipient_email])
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
        if TRACK_IP
          body = I18n.translate(:message_was_read_at_by_ip, :read_at => m.read_at, :remote_ip => m.recipient_ip)
        else
          body = I18n.translate(:message_was_read_at, :read_at => m.read_at)
        end
      end

      return body
    end
  end
end
