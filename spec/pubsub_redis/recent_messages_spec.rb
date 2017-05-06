require 'spec_helper'

RSpec.describe PubSubRedis::RecentMessages do
  let(:present_topics) do
    [
      '{"body":"message1","timestamp":1494009494}',
      '{"body":"message2","timestamp":1494009494}'
    ]
  end

  subject { described_class.new(message, checker) }

  describe '#to_a' do
    context 'when topics are present' do
      let(:checker) { ->(_) { present_topics } }
      let(:message) { { 'topics' => ['hello'] } }

      it 'is an instance of Array' do
        expect(subject.to_a).to be_an_instance_of(Array)
      end

      it 'results the expected array' do
        result = [
          [
            '[hello] 2017-05-05 21:38:14 +0300 : message1',
            '[hello] 2017-05-05 21:38:14 +0300 : message2'
          ]
        ]

        expect(subject.to_a).to eq(result)
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
      let(:checker) { ->(_) { present_topics } }
      let(:message) { { 'topics' => ['hello'] } }

      it 'is an instance of String' do
        expect(subject.to_json).to be_an_instance_of(String)
      end

      it 'results the expected array' do
        result = '[["[hello] 2017-05-05 21:38:14 +0300 : message1",'\
                 '"[hello] 2017-05-05 21:38:14 +0300 : message2"]]'

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
