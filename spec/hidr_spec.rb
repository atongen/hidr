# encoding: UTF-8
require 'spec_helper'

describe Cript::Hidr do
  let(:ascii) { SecureRandom.base64(10240) }
  let(:bytes) { SecureRandom.random_bytes(10240) }

  context "ascii out" do
    let(:hidr) { Cript::Hidr.ascii }

    it 'should echo ascii' do
      hidr.e(ascii).should eql(ascii)
    end

    it 'should echo bytes' do
      hidr.e(bytes).should eql(bytes)
    end
  end

  context "unicode out" do
    let(:hidr) { Cript::Hidr.unicode }

    it 'should echo ascii' do
      hidr.e(ascii).should eql(ascii)
    end

    it 'should echo bytes' do
      hidr.e(bytes).should eql(bytes)
    end
  end

  context "orly out" do
    let(:hidr) { Cript::Hidr.orly }

    it 'should echo ascii' do
      hidr.e(ascii).should eql(ascii)
    end

    it 'should echo bytes' do
      hidr.e(bytes).should eql(bytes)
    end
  end
end
