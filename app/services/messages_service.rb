require 'krypto'

class MessagesService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def store
    message = Message.new

    key, message.stub = loop do
      r = SecureRandom.base58(10)
      s = slice_and_dice(r: r)
      break r, s unless Message.exists?(stub: s)
    end

    salt = Krypto.salt_shaker(length: 8)
    skey = Krypto.strong_key(key: key, salt: salt, iterations: 2000)
    auth_data = slice_and_dice(r: key, range: 24..32)

    message.body = Krypto::AES.encrypt(cipher_suite: 'aes-256-gcm',
                                    key: skey,
                                    auth_data: auth_data,
                                    data: params[:message][:body])
                    .merge!(salt: salt.unpack('H*'))
                    .to_json

    message.expires_at = Time.now + 15.days
    message.save!

    key
  end

  def retrieve
    key = params[:id]
    record = Message.find_by!(stub: slice_and_dice(r: key))


    if record.read_at.nil?
      data = JSON.parse(record[:body])
      auth_data = slice_and_dice(r: key, range: 24..32)
      salt = data['salt'].pack('H*')

      skey = Krypto.strong_key(key: key, salt: salt, iterations: 2000)
      data = Krypto::AES.decrypt(key: skey, auth_data: auth_data, data: data)

      record.update!(body: 'DEADBEEF', read_at: Time.now)

      {
        read: nil,
        message: data
      }.to_json
    else
      {
          read: record.read_at,
          message: nil
      }.to_json
    end
  end

  def delete
  end

  private

  def slice_and_dice(r:, range: 4..16)
    OpenSSL::Digest::SHA256.hexdigest(r).slice(range)
  end
end
