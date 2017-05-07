require 'spec_helper'

RSpec.describe PubSubRedis::History do
  let(:message) do
    {
      'body' => 'message body',
      'topic' => 'cars'
    }
  end

  let(:timestamp) { 1_494_149_312 }

  subject { described_class.new(message, timestamp) }

  describe '.push' do
    it 'stores the message into redis' do
      described_class.push(message, timestamp)
      client = Redis.new
      result = '{"body":"message body","timestamp":1494149312}'

      expect(client.lpop('cars')).to eq result
    end
  end

  describe '#push' do
    it 'has the expected topic' do
      expect(subject.topic).to eq 'cars'
    end

    it 'has the expected body' do
      expect(subject.body).to eq 'message body'
    end

    it 'has the expected timestamp' do
      expect(subject.timestamp).to eq 1_494_149_312
    end

    it 'stores the message into redis' do
      subject.push
      client = Redis.new
      result = '{"body":"message body","timestamp":1494149312}'

      expect(client.lpop('cars')).to eq result
    end
  end
end
