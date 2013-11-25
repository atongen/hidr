require 'spec_helper'
require 'cript/hidr_command'

describe Cript::HidrCommand do

  context 'parse' do
    it 'should parse hide options' do
      c = Cript::HidrCommand.new("-h -0 a -1 b -i /tmp/in.txt -o /tmp/out.txt -f -D".split(" "))
      c.options[:mode].should eql('hide')
      c.options[:b0].should eql('a')
      c.options[:b1].should eql('b')
      c.options[:infile].should eql('/tmp/in.txt')
      c.options[:outfile].should eql('/tmp/out.txt')
      c.options[:force].should be_true
      c.options[:debug].should be_true
    end

    it 'should parse show options' do
      c = Cript::HidrCommand.new("-s -0 a -1 b -i /tmp/in.txt -o /tmp/out.txt -f -D".split(" "))
      c.options[:mode].should eql('show')
      c.options[:b0].should eql('a')
      c.options[:b1].should eql('b')
      c.options[:infile].should eql('/tmp/in.txt')
      c.options[:outfile].should eql('/tmp/out.txt')
      c.options[:force].should be_true
      c.options[:debug].should be_true
    end

    it 'should recognize built-in hidrs' do
      c = Cript::HidrCommand.new("-s -b orly -i /tmp/in.txt -o /tmp/out.txt -f -D".split(" "))
      hidr = c.send(:build_hidr)
      opts = hidr.instance_variable_get(:@o)
      opts[:b0].should eql("\u0CA0")
      opts[:b1].should eql("\u005F")
    end
  end
end
