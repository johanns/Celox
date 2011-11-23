require 'crypto'

class Message < ActiveRecord::Base
  include Crypto  

  validates :body, :presence => true
  validates :body, :length => { :maximum => 2048 }
  validates :stub, :uniqueness => true
  before_create :set_and_protect

  attr_accessor :key

  def self.retreive_message(key, m, remote_ip)
    read = false
    body = String.new
    
    unless m.read_at
      body = CeloxCrypto.decrypt(key, m.body)
      m.read_at = Time.now
      m.body = APP_READ_MARKER # => body cannot be blank
      
      m.recipient_ip = remote_ip if APP_TRACK_IP

      m.save
    else
      read = true

      body = APP_TRACK_IP ? I18n.t(:message_was_read_at_by_ip, :read_at => time_ago_in_words(m.read_at), :remote_ip => m.recipient_ip) : 
                         I18n.t(:message_was_read_at, :read_at => time_ago_in_words(m.read_at))
    end
      
    return [read, body]
  end

  # Override json response to limit fields returned
  def as_json(options = {})
    super(:only => [:body])
  end

private
  def set_and_protect
    begin
      self.key = CeloxCrypto.generate_key(APP_KEY_LENGTH)
      self.body = CeloxCrypto.encrypt(APP_CIPHER, @key, body)
      self.stub = CeloxCrypto.hash_key(key)
      self.created_at = Time.now
      self.expires_at = Time.now + 15.days
      self.sender_ip = remote_ip if APP_TRACK_IP
   rescue
     return false
   end

    true
  end
end
