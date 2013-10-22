#
# Cript::Simple
#
require 'openssl'
require 'base64'

module Cript
  # Cript::Simple is a simple ruby wrapper around RSA SSH keys and a blowfish cipher.
  # It allows you to easily encrypt and decrypt strings.
  class Simple < Cripter

    def encrypt(message)
      cipher = OpenSSL::Cipher::Cipher.new('bf-cbc').encrypt
      key = cipher.random_key
      iv = cipher.random_iv
      encrypted_message = cipher.update(message) + cipher.final
      encrypted_key = public_key.public_encrypt(key)
      Base64::encode64(Marshal.dump([encrypted_key,iv,encrypted_message]))
    end

    def decrypt(message)
      encrypted_key, iv, encrypted_message = Marshal.load(Base64::decode64(message))
      key = private_key.private_decrypt(encrypted_key)
      cipher = OpenSSL::Cipher::Cipher.new('bf-cbc').decrypt
      cipher.key = key
      cipher.iv = iv
      cipher.update(encrypted_message) + cipher.final
    end

  end
end
