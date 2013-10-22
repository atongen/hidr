require 'spec_helper'
require 'cript/conc'

describe Cript::Conc do
  let(:conc) do
    Cript::Conc.new({
      private_key_content: Cript::PRIVATE_KEY,
      public_key_content: Cript::PUBLIC_KEY,
      size: Cript::KEY_SIZE
    })
  end
  let(:small_data) { SecureRandom.random_bytes }
  let(:big_data) { SecureRandom.random_bytes(102400) }

  it 'should echo small data' do
    conc.echo(small_data).should eql(small_data)
  end

  it 'should echo big data' do
    conc.echo(big_data).should eql(big_data)
  end
end
