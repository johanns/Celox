require 'crypto'

class Message < ActiveRecord::Base
  include Crypto

  attr_accessible :body

  validates :body, :presence => true
  validates :body, :length => { :maximum => 2048 }
  validates :stub, :uniqueness => true
  before_create :set_and_protect

  attr_accessor :key

  def self.retrieve_message(key, m, remote_ip)
    unless m.read_at
      body = CeloxCrypto.decrypt(key, m.body)
      m.read_at = Time.now
      m.body = APP_READ_MARKER # => body cannot be blank

      m.recipient_ip = remote_ip if APP_TRACK_IP

      m.save

      return { :read => false, :body => body }
    end

    return { :read => true, :read_at => m.read_at, :recipient_ip => m.recipient_ip }
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
    rescue
      return false
    end
    true
  end
end
