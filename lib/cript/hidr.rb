# encoding: UTF-8
#
# Cript::Hidr
#
module Cript
  # Hidr can be used to obscure strings in other utf-8 strings.
  # This is not encryption, and it's not secure!
  class Hidr
    def initialize(*o)
      @o = o.last.is_a?(Hash) ? o.pop : {}
      @o[:b0] ||= "\u200B"
      @o[:b1] ||= "\uFEFF"
    end
    module I
      def h(m);m.unpack('b*').first.split("").map{|v|v=='0'?@o[:b0]:@o[:b1]}.join;end
      def s(n);[n.chars.to_a.map{|y|y==@o[:b0]?'0':'1'}.join].pack('b*');end
      def e(o);s(h(o));end
    end
    include I
  end
end
