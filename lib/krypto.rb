require 'openssl'

module Krypto
  module AES
    # cipher_suite: aes-*-cbc, aes-*-ctr, aes-*-gcm
    def self.encrypt(cipher_suite:, key:, auth_data:, data:)
      cipher = OpenSSL::Cipher.new(cipher_suite)
      cipher.encrypt
      cipher.key = key
      cipher.iv = iv = cipher.random_iv
      cipher.auth_data = auth_data
      encrypted = cipher.update(data) + cipher.final

      {
          cipher: cipher_suite,
          iv: iv.unpack('H*'),
          auth_tag: cipher.auth_tag.unpack('H*'),
          data: encrypted.unpack('H*')
      }
    end

    def self.decrypt(key:, auth_data:, data:)
      cipher = OpenSSL::Cipher.new(data['cipher'])
      cipher.decrypt
      cipher.key = key
      cipher.iv = data['iv'].pack('H*')
      cipher.auth_tag = data['auth_tag'].pack('H*')
      cipher.auth_data = auth_data
      cipher.update(data['data'].pack('H*')) + cipher.final
    end
  end

  def self.strong_key(key:, salt:, iterations:)
    digest = OpenSSL::Digest::SHA256.new
    OpenSSL::PKCS5.pbkdf2_hmac(key, salt, iterations, digest.length, digest)
  end

  def self.salt_shaker(length:)
    OpenSSL::Random.random_bytes(length)
  end
end
