require 'spec_helper'

class FakeConnection
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def recv(*)
    params.to_json
  end
end

RSpec.describe PubSubRedis::InboundMessage do
  let(:broker) { PubSubRedis::Broker.new }

  subject { described_class.new(connection, broker) }

  describe '#subscription?' do
    let(:connection) { FakeConnection.new(topics: %w[coffee alcohol]) }

    context 'when message has the topics attribute' do
      it 'has the expected payload' do
        expect(subject.payload).to eq('topics' => %w[coffee alcohol])
      end

      it 'returns true' do
        expect(subject.subscription?).to eq true
      end
    end

    context 'when message has the topic/body param pair' do
      let(:connection) do
        FakeConnection.new(
          topic: %w[coffee alcohol],
          body: 'lorem ipsum'
        )
      end

      it 'has the expected payload' do
        content = [
          ['body', 'lorem ipsum'],
          ['topic', %w[coffee alcohol]]
        ]

        expect(subject.payload).to contain_exactly(*content)
      end

      it 'returns false' do
        expect(subject.subscription?).to eq false
      end
    end
  end

  describe '#publish' do
    context 'when payload holds subscription message' do
      let(:connection) { FakeConnection.new(topics: %w[coffee alcohol]) }

      it 'is a subscription' do
        expect(subject.subscription?).to eq true
      end

      it 'returns nil' do
        expect(subject.publish).to be_nil
      end
    end

    context 'when payload holds publisher message' do
      # TODO
    end
  end

  describe '#subscribe' do
    context 'when payload holds publisher message' do
      let(:connection) do
        FakeConnection.new(
          topic: %w[coffee alcohol],
          body: 'lorem ipsum'
        )
      end

      it 'is not a subscription' do
        expect(subject.subscription?).to eq false
      end

      it 'returns nil' do
        expect(subject.subscribe).to be_nil
      end
    end
  end
end
