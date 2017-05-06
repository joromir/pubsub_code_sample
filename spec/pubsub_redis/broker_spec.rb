require 'spec_helper'

RSpec.describe PubSubRedis::Broker do
  describe '#add_topic' do
    context 'when new topic is being inserted' do
      it 'has a empty topics hash initially' do
        expect(subject.topics).to be_empty
      end

      it 'adds the new key value pair' do
        connection = 'i am a connection'

        input = {
          topic: 'rockandroll',
          connection: connection
        }

        subject.add_topic(input)
        expect(subject.topics).to eq('rockandroll' => ['i am a connection'])
      end
    end

    context 'when the same topic already exists' do
      before(:each) do
        subject.add_topic(topic: 'rockandroll', connection: 'connection1')
      end

      it 'has a nonempty topics collection' do
        expect(subject.topics).to eq('rockandroll' => ['connection1'])
      end

      it 'updates the existing key as expected' do
        subject.add_topic(topic: 'rockandroll', connection: 'connection2')

        result = { 'rockandroll' => %w[connection1 connection2] }

        expect(subject.topics).to eq(result)
      end
    end
  end
end
