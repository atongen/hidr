require 'spec_helper'

describe Cript::Naive do
  let(:naive) do
    Cript::Simple.new({
      private_key_content: Cript::PRIVATE_KEY,
      public_key_content: Cript::PUBLIC_KEY,
      size: Cript::KEY_SIZE
    })
  end
  let(:small_data) { SecureRandom.random_bytes }
  let(:big_data) { SecureRandom.random_bytes(102400) }

  it 'should echo small data' do
    naive.echo(small_data).should eql(small_data)
  end

  it 'should echo big data' do
    naive.echo(big_data).should eql(big_data)
  end
end
