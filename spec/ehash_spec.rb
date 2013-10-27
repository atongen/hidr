require 'spec_helper'
require 'fileutils'

describe Cript::EHash do
  let(:file) { '/tmp/cript-spec.store' }

  before(:each) do
    FileUtils.rm(file) if File.file?(file)
  end

  after(:each) do
    FileUtils.rm(file) if File.file?(file)
  end

  it 'should encrypt and decrypt' do
    e = Cript::EHash.new(file, private_key_content: Cript::PRIVATE_KEY, public_key_content: Cript::PUBLIC_KEY)
    data = 10.times.inject({}) { |data,i| data[SecureRandom.hex] = SecureRandom.random_bytes(4096); data }
    data.keys.each do |key|
      e[key] = data[key]
    end
    File.file?(file).should be_true
    e.keys.should eql(data.keys)
    data.keys.each do |key|
      e[key].should eql(data[key])
    end
  end
end
