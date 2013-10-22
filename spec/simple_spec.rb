require 'spec_helper'

describe Cript::Simple do
  let(:simple) do
    Cript::Simple.new({
      private_key_content: Cript::PRIVATE_KEY,
      public_key_content: Cript::PUBLIC_KEY
    })
  end
  let(:small_data) { SecureRandom.random_bytes }
  let(:big_data) { SecureRandom.random_bytes(1048576) }

  it 'should echo small data' do
    simple.echo(small_data).should eql(small_data)
  end

  it 'should echo big data' do
    simple.echo(big_data).should eql(big_data)
  end
end
