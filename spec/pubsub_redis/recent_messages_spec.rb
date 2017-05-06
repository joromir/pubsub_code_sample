require 'spec_helper'

RSpec.describe PubSubRedis::RecentMessages do
  subject { described_class.new(message, checker) }

  describe '#to_a' do
    context 'when topics are present' do
      let(:checker) do
        lambda do |_|
          [
            { 'body' => 'message1', 'timestamp' => 1_494_009_494 },
            { 'body' => 'message2', 'timestamp' => 1_494_009_494 }
          ]
        end
      end

      let(:message) { { 'topics' => ['hello'] } }

      xit 'is an instance of Array' do
        expect(subject.to_a).to be_an_instance_of(Array)
      end

      xit 'results the expected array' do
        expect(subject.to_a).to eq [['[hello] message1', '[hello] message2']]
      end
    end

    context 'when topics are absent' do
      let(:message) { { 'topics' => [] } }
      let(:checker) { ->(_) { [] } }

      it 'results the expected array' do
        expect(subject.to_a).to eq []
      end
    end
  end

  describe '#to_json' do
    context 'when topics are present' do
      let(:checker) do
        lambda do |_|
          [
            { 'body' => 'message1', 'timestamp' => 1_494_009_494 },
            { 'body' => 'message2', 'timestamp' => 1_494_009_494 }
          ]
        end
      end

      let(:message) { { 'topics' => ['hello'] } }

      xit 'is an instance of String' do
        expect(subject.to_json).to be_an_instance_of(String)
      end

      xit 'results the expected array' do
        result = '[["[hello] message1","[hello] message2"]]'

        expect(subject.to_json).to eq result
      end
    end

    context 'when topics are absent' do
      let(:message) { { 'topics' => [] } }
      let(:checker) { ->(_) { [] } }

      it 'results the expected array' do
        expect(subject.to_json).to eq '[]'
      end
    end
  end
end
