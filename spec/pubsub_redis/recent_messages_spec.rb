require 'spec_helper'

RSpec.describe PubSubRedis::RecentMessages do
  subject { described_class.new(message, checker) }

  describe '#to_a' do
    context 'when topics are present' do
      let(:checker) do
        ->(_) { %w[message1 message2] }
      end

      let(:message) { { 'topics' => ['hello'] } }

      it 'is an instance of Hash' do
        expect(subject.to_a).to be_an_instance_of(Array)
      end

      it 'results the expected array' do
        expect(subject.to_a).to eq [['[hello] message1', '[hello] message2']]
      end
    end

    context 'when topics are absent' do
      let(:message) { { 'topics' => [] } }

      let(:checker) do
        ->(_) { [] }
      end

      it 'results the expected array' do
        expect(subject.to_a).to eq []
      end
    end
  end

  describe '#to_json' do
    context 'when topics are present' do
      let(:checker) do
        ->(_) { %w[message1 message2] }
      end

      let(:message) { { 'topics' => ['hello'] } }

      it 'is an instance of String' do
        expect(subject.to_json).to be_an_instance_of(String)
      end

      it 'results the expected array' do
        result = "[[\"[hello] message1\",\"[hello] message2\"]]"

        expect(subject.to_json).to eq result
      end
    end

    context 'when topics are absent' do
      let(:message) { { 'topics' => [] } }

      let(:checker) do
        ->(_) { [] }
      end

      it 'results the expected array' do
        expect(subject.to_json).to eq '[]'
      end
    end
  end
end
