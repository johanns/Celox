require 'digest/sha2'
require 'openssl'
require 'base64'

module Crypto 
  class CeloxCrypto
    class << self
    # Cipher_name: aes-128-cbc, aes-192-cbc, aes-256-cbc
      def encrypt(cipher_name, key, data)
        raise ArgumentError.new("Data cannot be empty!") if data.empty?

        cipher = OpenSSL::Cipher::Cipher.new(cipher_name)

        # Generate random salt
        salt = generate_salt

        # Protect, and generate cipher key from supplied key.
        # This is probably redundant considering that we're generating
        # a random key -- implemented for good measure.
        key = generate_strong_key(key, salt, cipher.key_len)

        cipher.encrypt
        cipher.key = key
        cipher.iv = iv = cipher.random_iv

        # Encrypt and finalize the stream
        enc = cipher.update(data) + cipher.final

        return Base64.encode64(Marshal.dump([cipher_name, salt, iv, enc]))
      end

      def decrypt(key, data)  
        raise ArgumentError.new("Key/Data cannot be empty!") if key.empty? and data.empty?

        cipher_name, salt, iv, enc = Marshal.load(Base64.decode64(data))

        cipher = OpenSSL::Cipher::Cipher.new(cipher_name)

        cipher.iv = iv
        dec = enc

        cipher.decrypt

        cipher.key = generate_strong_key(key, salt, cipher.key_len)
        #Decrypt and return our data
        dec = cipher.update(enc) + cipher.final
      end

      def generate_salt
        # Hoping OpenSSL's implantation is superior
        OpenSSL::Random.random_bytes(8)  
      end

      def generate_key(length)
        chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
        key = String.new
        length.times { key << chars[rand(chars.size - 1)] }

        key
      end

      def generate_strong_key(key, salt, length)
        OpenSSL::PKCS5::pbkdf2_hmac_sha1(key, salt, 2048, length)
      end

      def hash_key(key)
        (Digest::SHA2.new << key).to_s
      end
    end
  end
end

