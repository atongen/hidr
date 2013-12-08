# Hidr

Hide your strings!

[![Build Status](https://travis-ci.org/atongen/hidr.png)](https://travis-ci.org/atongen/hidr)

## Installation

Add this line to your application's Gemfile:

    gem 'hidr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hidr

## Usage

Hidr allows you to obscure strings in other strings by facilitating a two-way conversion
between a string and a binary version of that string.

The resulting binary characters can be any two charaters. By default it uses a space and a tab.

```ruby
h = hidr::Hidr.new(b0: 'a', b1: 'z')
result = h.hide('Wow!')
```

After running this code, result will contain "zzzazazazzzzazzazzzazzzazaaaazaa".

It comes with a few commonly used mappings already setup: ascii, unicode, orly.
Call the class method of the same name to get these hidrs.

You can use Hidr from bash with the `hidr` executable. For example:

```
% echo Some important stuff | bin/hidr -h
110010101111011010110110101001100000010010010110101101100000111011110110010011100010111010000110011101100010111000000100110011100010111010101110011001100110011001010000
```

or even

```
% echo Some important stuff | bin/hidr -h | bin/hidr -s
Some important stuff
```

Type `hidr --help` after gem installation for usage.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
