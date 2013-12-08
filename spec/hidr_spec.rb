require 'spec_helper'

describe Hidr do
  let(:hidr)  { nil }
  let(:ascii) { SecureRandom.base64(10240) }
  let(:bytes) { SecureRandom.random_bytes(10240) }

  context "ascii out" do
    let(:hidr) { Hidr.ascii }

    it 'should echo ascii' do
      hidr.echo(ascii).should eql(ascii)
    end

    it 'should echo bytes' do
      hidr.echo(bytes).should eql(bytes)
    end
  end

  context "unicode out" do
    let(:hidr) { Hidr.unicode }

    it 'should echo ascii' do
      hidr.echo(ascii).should eql(ascii)
    end

    it 'should echo bytes' do
      hidr.echo(bytes).should eql(bytes)
    end
  end
end
