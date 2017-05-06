require 'spec_helper'

RSpec.describe PubSubRedis::MinutesAgo do
  let(:dummy_class) do
    Class.new do
      include PubSubRedis::MinutesAgo
    end
  end

  subject { dummy_class.new }

  describe '#expired?' do
    context 'when timestamp is in the range of 30 minutes' do
      let(:timestamp) { Time.now.to_i }

      it 'returns true' do
        expect(subject.expired?(timestamp)).to eq true
      end
    end

    context 'when timestamp is NOT in the range of 30 minutes' do
      let(:timestamp) { subject.minutes_ago(50) }

      it 'returns false' do
        expect(subject.expired?(timestamp)).to eq false
      end
    end
  end

  describe '#minutes_ago' do
    it 'substracts 30 minutes from the current time' do
      sample_format = '%Y-%M-%D-%H-%M'
      expected = (Time.now - (30 * 60)).strftime(sample_format)
      expect(subject.minutes_ago(30).strftime(sample_format)).to eq expected
    end
  end

  describe '#timestamp' do
    context 'when input is JSON string' do
      let(:json_message) do
        { timestamp: 1_494_080_762 }.to_json
      end

      it 'returns the expected timestamp' do
        expect(subject.timestamp(json_message)).to eq 1_494_080_762
      end
    end
  end
end
