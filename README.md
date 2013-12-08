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

You can use Hidr from bash with the `hidr` executable.
Type `hidr --help` after gem installation for usage.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
