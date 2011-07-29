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
  
  class << self
    def new_message(m)
      #debugger
      key = Message.generate_key(KEY_SIZE)
      m.body = Message.encrypt(CIPHER, key, m.body)
      m.stub = Message.hash_key(key)
      m.created_at = Time.now
      return m.save && key
    end
    
    def retrive_message(key, m)
      #debugger
      read = false
      body = String.new
      
      unless (m.body == 'READ')
        body = Message.decrypt(key, m.body)
        m.read_at = Time.now
        m.body = "READ" # => body cannot be blank
        m.save
      end
      
      return body
    end
  end
end
