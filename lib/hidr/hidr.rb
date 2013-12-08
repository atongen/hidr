require 'hidr/impl'

module Hidr
  class Hidr
    include Impl

    def initialize(*o)
      @o = o.last.is_a?(Hash) ? o.pop : {}
      @o[:b0] ||= ::Hidr::CHARS[:ascii].first
      @o[:b1] ||= ::Hidr::CHARS[:ascii].last
    end
  end
end
