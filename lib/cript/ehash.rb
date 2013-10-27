#
# Cript::Hash
#
module Cript
  # A hash backed by a Cript::Store object.
  # All methods sent to an instance of this object are
  # wrapped in a transaction and executed immediately.
  class EHash

    METHODS = Hash.new.methods - Object.new.methods
    KEY = :data

    def initialize(file, options = {})
      @store = Store.new(file, options)
      @store.transaction do
        unless @store[KEY].is_a?(Hash)
          @store[KEY] = {}
        end
      end
    end

    def inspect
      "#<#{self.class.name} path='#{@store.path}'>"
    end

    def method_missing(sym, *args, &block)
      super if !METHODS.include?(sym) || block_given?

      @store.transaction do
        @store[KEY].send(sym, *args)
      end
    end

    def respond_to?(sym)
      METHODS.include?(sym)
    end

  end
end
