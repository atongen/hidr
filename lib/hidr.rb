require "hidr/version"
require "hidr/hidr"

# Hidr can be used to obscure strings in other utf-8 strings.
# This is not encryption, it's obfuscation.
module Hidr
  CHARS = {
    binary:  ["0", "1"],
    ascii:   ["\s","\t"],
    unicode: ["\u200B","\uFEFF"],
    orly:    ["\u0CA0", "\u005F"],
    niceday: ["\s", "\u263A"]
  }

  class << self
    def build(type)
      if CHARS.has_key?(type)
        ::Hidr::Hidr.new(b0: CHARS[type].first, b1: CHARS[type].last)
      end
    end
    CHARS.keys.each { |key| class_eval("def #{key}; build(:#{key}); end") }
  end
end
