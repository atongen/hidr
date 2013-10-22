#
# Cript::Conc
#
require 'openssl'
require 'base64'
require 'cript/naive'
require 'cript/pmap'

module Cript
  # Cript::Conc takes the concept from Cript::Naive and adds concurrency to it.
  class Conc < Naive

    # RSA encryption requires 11 bytes padding
    def encrypt(message)
      Base64::encode64(
        message.
        bytes.
        each_slice((size / 8) - 11).
        pmap { |chunk| public_key.public_encrypt(chunk.pack('C*')) }.
        join)
    end

    def decrypt(message)
      Base64::decode64(message).
        bytes.
        each_slice(size / 8).
        pmap { |chunk| private_key.private_decrypt(chunk.pack('C*')) }.
        join
    end

  end
end
