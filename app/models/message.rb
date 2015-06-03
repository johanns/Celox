# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  body       :text
#  stub       :string
#  expires_at :datetime
#  created_at :datetime
#  updated_at :datetime
#  read_at    :datetime
#
# Indexes
#
#  index_messages_on_stub  (stub)
#

require 'krypto'

class Message < ActiveRecord::Base
  attr_reader :key

  validates :body, presence: true, length: { maximum: 4096 }

  before_create -> {
    @key, self.stub = loop do
      r = Krypto.base58(6)
      s = Message.slice_and_dice(r: r)
      break r, s unless self.class.exists?(stub: s)
    end

    salt = Krypto.salt_shaker(length: 8)
    skey = Krypto.strong_key(key: @key, salt: salt, iterations: 2000)
    auth_data = Message.slice_and_dice(r: @key, range: 24..32)

    self.body = Krypto::AES.encrypt(cipher_suite: 'aes-256-gcm',
                                    key: skey,
                                    auth_data: auth_data,
                                    data: body)
                    .merge!(salt: salt.unpack('H*'))
                    .to_json

    self.expires_at = Time.now + 15.days
  }

  scope :fetch_message, -> (key:) {
    record = Message.where(stub: Message.slice_and_dice(r: key)).first

    raise ActiveRecord::RecordNotFound, 'message not found' if record.nil?

    if record.read_at.nil?
      data = JSON.parse(record[:body])
      auth_data = Message.slice_and_dice(r: key, range: 24..32)
      salt = data['salt'].pack('H*')

      skey = Krypto.strong_key(key: key, salt: salt, iterations: 2000)
      data = Krypto::AES.decrypt(key: skey, auth_data: auth_data, data: data)

      record.update!(body: 'DEADBEEF', read_at: Time.now)

      data
    else
      {
          read: true,
          message: "This message was read and destroyed at #{record.read_at}"
      }.to_json
    end
  }

  def self.slice_and_dice(r:, range: 4..16)
    OpenSSL::Digest::SHA256.hexdigest(r).slice(range)
  end
end
