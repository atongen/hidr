require 'spec_helper'
require 'hidr/hidr_command'

describe Hidr::HidrCommand do

  subject(:cmd) { Hidr::HidrCommand.new(args.split(" ")) }
  let(:args) { nil }

  context 'parse' do
    context 'hide' do
      let(:args) { "-h -0 a -1 b -i /tmp/in.txt -o /tmp/out.txt -f -D" }

      it 'should parse hide options' do
        cmd.options[:mode].should eql('hide')
        cmd.options[:b0].should eql('a')
        cmd.options[:b1].should eql('b')
        cmd.options[:infile].should eql('/tmp/in.txt')
        cmd.options[:outfile].should eql('/tmp/out.txt')
        cmd.options[:force].should be_true
        cmd.options[:debug].should be_true
      end
    end

    context 'show' do
      let(:args) { "-s -0 a -1 b -i /tmp/in.txt -o /tmp/out.txt -f -D" }

      it 'should parse show options' do
        cmd.options[:mode].should eql('show')
        cmd.options[:b0].should eql('a')
        cmd.options[:b1].should eql('b')
        cmd.options[:infile].should eql('/tmp/in.txt')
        cmd.options[:outfile].should eql('/tmp/out.txt')
        cmd.options[:force].should be_true
        cmd.options[:debug].should be_true
      end
    end

    context 'builtin' do
      let(:args) { "-s -b orly -i /tmp/in.txt -o /tmp/out.txt -f -D" }

      it 'should recognize built-in hidrs' do
        hidr = cmd.send(:build_hidr)
        opts = hidr.instance_variable_get(:@o)
        opts[:b0].should eql("\u0CA0")
        opts[:b1].should eql("\u005F")
      end
    end
  end
end
