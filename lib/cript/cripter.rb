#
# Cript::Cripter
#
require 'openssl'
require 'base64'

module Cript
  # Cript::Cripter is an abstract class for encryption implementations using RSA keys.
  class Cripter

    class Error < StandardError; end

    # Options:
    # public_key_content
    # private_key_content
    # public_key_path
    # private_key_path
    # passphrase
    def initialize(options = {})
      @opt = options

      unless [:public_key_content, :private_key_content, :public_key_path, :private_key_path].any? { |o| @opt[o] }
        if File.file?("#{ENV['HOME']}/.ssh/id_rsa")
          @opt[:private_key_path] = "#{ENV['HOME']}/.ssh/id_rsa"
        end
        if File.file?("#{ENV['HOME']}/.ssh/id_rsa.pub")
          @opt[:public_key_path] = "#{ENV['HOME']}/.ssh/id_rsa.pub"
        end
      end

      if [:private_key_content, :private_key_path].any? { |o| @opt[o] }
        @private_key = OpenSSL::PKey::RSA.new(*[private_key_content, @opt.delete(:passphrase)])
      end
      if [:public_key_content, :public_key_path].any? { |o| @opt[o] }
        @public_key = OpenSSL::PKey::RSA.new(public_key_content)
      end
    end

    def inspect
      "#<#{self.class.name}>"
    end

    def encrypt(message)
      raise Cript::Cripter::Error, "Implement me"
    end

    def decrypt(message)
      raise Cript::Cripter::Error, "Implement me"
    end

    def echo(message)
      decrypt(encrypt(message))
    end

    private

    def private_key_content
      if @opt[:private_key_content]
        @opt[:private_key_content]
      elsif @opt[:private_key_path]
        content = File.read(@opt[:private_key_path])
        if content.include?("PRIVATE KEY")
          content
        else
          ssh_key_to_pem(@opt[:private_key_path])
        end
      else
        raise self.class::Error, "No private key content"
      end
    end

    def public_key_content
      if @opt[:public_key_content]
        @opt[:public_key_content]
      elsif @opt[:public_key_path]
        content = File.read(@opt[:public_key_path])
        if content.include?("PUBLIC KEY")
          content
        else
          ssh_key_to_pem(@opt[:public_key_path])
        end
      else
        raise self.class::Error, "No public key content"
      end
    end

    def ssh_key_to_pem(path)
      ssh_keygen("-f \"#{path}\" -e -m pem")
    end

    def ssh_keygen(cmd)
      ssh_keygen = %x{ which ssh-keygen }.to_s.strip
      if ssh_keygen != ""
        %x{ #{ssh_keygen} #{cmd} }.to_s.strip
      else
        raise "ssh-keygen not available"
      end
    end

  end
end
