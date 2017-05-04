require 'spec_helper'

RSpec.describe PubSubRedis::LocationTuple do
  describe '#host' do
    it 'responds to host' do
      expect(subject).to respond_to :host
    end

    context 'when no particular host is given' do
      it 'has the default injected host of 20_000' do
        expect(subject.host).to eq 'localhost'
      end
    end
  end

  describe '#port' do
    it 'responds to port' do
      expect(subject).to respond_to :port
    end

    context 'when no particular port is given' do
      it 'has the default injected port of 20_000' do
        expect(subject.port).to eq 20_000
      end
    end
  end
end
