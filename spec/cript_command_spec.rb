require 'spec_helper'
require 'cript/cript_command'

describe Cript::CriptCommand do

  context 'parse' do
    it 'should parse encrypt options' do
      c = Cript::CriptCommand.new("-e --public /tmp/fake_key.pub -i /tmp/in.txt -o /tmp/out.txt -f -D".split(" "))
      c.options[:mode].should eql('encrypt')
      c.options[:public].should eql('/tmp/fake_key.pub')
      c.options[:infile].should eql('/tmp/in.txt')
      c.options[:outfile].should eql('/tmp/out.txt')
      c.options[:force].should be_true
      c.options[:debug].should be_true
    end

    it 'should parse decrypt options' do
      c = Cript::CriptCommand.new("-d --private /tmp/fake_key -i /tmp/in.txt -o /tmp/out.txt -f -D".split(" "))
      c.options[:mode].should eql('decrypt')
      c.options[:private].should eql('/tmp/fake_key')
      c.options[:infile].should eql('/tmp/in.txt')
      c.options[:outfile].should eql('/tmp/out.txt')
      c.options[:force].should be_true
      c.options[:debug].should be_true
    end
  end
end
