#
# Cript::EHash
#
module Cript
  # A hash backed by a Cript::EStore object.
  # All methods sent to an instance of this object are
  # wrapped in a transaction and executed immediately.
  class EHash

    METHODS = Hash.new.methods - Object.new.methods
    KEY = :data

    def initialize(file, options = {})
      @estore = EStore.new(file, options)
      @estore.transaction do
        unless @estore[KEY].is_a?(Hash)
          @estore[KEY] = {}
        end
      end
    end

    def inspect
      "#<#{self.class.name} path='#{@estore.path}'>"
    end

    def method_missing(sym, *args, &block)
      super if !METHODS.include?(sym) || block_given?

      @estore.transaction do
        @estore[KEY].send(sym, *args)
      end
    end

    def respond_to?(sym)
      METHODS.include?(sym)
    end

  end
end
