# encoding: UTF-8
require 'spec_helper'

describe Cript::Hidr do
  let(:hidr) { Cript::Hidr.new }
  let(:small_ascii) { SecureRandom.base64 }
  let(:small_bytes) { SecureRandom.random_bytes }
  let(:big_ascii) { SecureRandom.base64(102400) }
  let(:big_bytes) { SecureRandom.random_bytes(102400) }

  it 'should echo small ascii' do
    hidr.e(small_ascii).should eql(small_ascii)
  end

  it 'should echo small bytes' do
    hidr.e(small_bytes).should eql(small_bytes)
  end

  it 'should echo big ascii' do
    hidr.e(big_ascii).should eql(big_ascii)
  end

  it 'should echo big bytes' do
    hidr.e(big_bytes).should eql(big_bytes)
  end
end
