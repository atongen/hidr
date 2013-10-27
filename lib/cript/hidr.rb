# encoding: UTF-8
#
# Cript::Hidr
#
module Cript
  # Hidr can be used to obscure strings in other utf-8 strings.
  # This is not encryption, and it's not secure!
  class Hidr

    CHARS = {
      ascii:   ["\s","\t"],
      unicode: ["\u200B","\uFEFF"],
      orly:    ["\u0CA0", "\u005F"]
    }

    class << self
      def build(type)
        if CHARS.has_key?(type)
          new(b0: CHARS[type].first, b1: CHARS[type].last)
        end
      end
      CHARS.keys.each { |key| class_eval("def #{key}; build(:#{key}); end") }
    end

    def initialize(*o)
      @o = o.last.is_a?(Hash) ? o.pop : {}
      @o[:b0] ||= CHARS[:ascii].first
      @o[:b1] ||= CHARS[:ascii].last
    end

    def h(m);m.unpack('b*').first.split("").map{|v|v=='0'?@o[:b0]:@o[:b1]}.join;end
    def s(n);[n.chars.to_a.map{|y|y==@o[:b0]?'0':'1'}.join].pack('b*');end
    def e(o);s(h(o));end
    { hide: :h, show: :s, echo: :e }.each { |k,v| alias_method k, v }
  end
end
