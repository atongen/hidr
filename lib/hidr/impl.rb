# encoding: UTF-8
#
# Hidr::Impl provides methods that convert a string
# to and from a binary representation.
module Hidr
  module Impl
    def h(m);m.unpack('b*').first.split("").map{|v|v=='0'?@o[:b0]:@o[:b1]}.join;end
    def s(n);[n.chars.to_a.map{|y|y==@o[:b0]?'0':'1'}.join].pack('b*');end
    def e(o);s(h(o));end
    { hide: :h, show: :s, echo: :e }.each { |k,v| alias_method k, v }
  end
end
