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
  
  class << self
    def new_message(m, remote_ip)
      #debugger
      key = Message.generate_key(KEY_SIZE)
      m.body = Message.encrypt(CIPHER, key, m.body)
      m.stub = Message.hash_key(key)
      m.sender_ip = remote_ip
      m.created_at = Time.now
      return m.save && key
    end
    
    def retrive_message(key, m, remote_ip)
      #debugger
      read = false
      body = String.new
      
      unless m.read_at
        body = Message.decrypt(key, m.body)
        m.recipient_ip = remote_ip
        m.read_at = Time.now
        m.body = READ_MARKER # => body cannot be blank
        m.save
      else
        body = "Message was read by #{m.recipient_ip} at #{m.read_at}"
      end
      
      return body
    end
  end
end
