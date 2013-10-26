#
# Cript::Naive
#
require 'openssl'
require 'base64'

module Cript
  # Cript::Naive uses rsa keys to encrypt data.
  # It allows you to easily encrypt and decrypt strings.
  # Performance is poor because rsa public keys were not meant to do this.
  class Naive < Cripter

    class Error < StandardError; end

    # Options:
    # public_key_content
    # private_key_content
    #
    # public_key_path
    # private_key_path
    #
    # passphrase
    #
    # type
    # size
    # fingerprint
    # comment
    def initialize(options = {})
      super
    end

    def inspect
      "#<#{self.class.name} path=#{@opt[:public_key_path]}>"
    end

    def type
      @opt[:type] || key_info[:type]
    end

    def size
      @opt[:size] || key_info[:size]
    end

    def fingerprint
      @opt[:fingerprint] || key_info[:fingerprint]
    end

    def comment
      @opt[:comment] || key_info[:comment]
    end

    def encrypt(message)
      Base64::encode64(
        message.
        bytes.
        each_slice((size / 8) - 11).
        map { |chunk| @public_key.public_encrypt(chunk.pack('C*')) }.
        join)
    end

    def decrypt(message)
      Base64::decode64(message).
        bytes.
        each_slice(size / 8).
        map { |chunk| @private_key.private_decrypt(chunk.pack('C*')) }.
        join
    end

    private

    def key_info
      @key_info ||= begin
        if @opt[:public_key_path]
          info = ssh_keygen("-l -f \"#{@opt[:public_key_path]}\"").split(/[\s]+/)
          if info.length == 4
            { size: info[0].to_i, fingerprint: info[1], comment: info[2], type: info[3].match(/([\w]+)/)[1].downcase }
          end
        end
      end
    end

  end
end
