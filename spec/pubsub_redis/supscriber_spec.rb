require 'spec_helper'

RSpec.describe PubSubRedis::Subscriber do
  let(:fake_socket) do
    Class.new do
      def initialize(path, port); end
      def gets(*); end
    end
  end

  subject { described_class.new(PubSubRedis::LocationTuple.new, fake_socket) }

  describe '#enroll' do
    context 'when new topic is being added' do
      it 'has no topics initially' do
        expect(subject.topics).to be_empty
      end

      it 'changes the size of topics' do
        invocation = proc { subject.enroll('cars') }

        expect(&invocation).to change { subject.topics }.by(['cars'])
      end
    end

    context 'when new topic is already in the list' do
      before(:each) { subject.enroll('cars') }

      it 'has topic' do
        expect(subject.topics).to contain_exactly('cars')
      end

      it 'returns nil when trying to add the same topic' do
        expect(subject.enroll('cars')).to be_nil
      end

      it 'does not change the list of topics' do
        expect { subject.enroll('cars') }.to_not(change { subject.topics })
      end
    end
  end

  describe '#to_h' do
    it 'returns an instance of Hash' do
      expect(subject.to_h).to be_an_instance_of(Hash)
    end

    context 'when no topics are selected' do
      it 'holds the expected data' do
        expect(subject.to_h).to eq(topics: [])
      end
    end
  end

  describe '#process_incoming_data' do
    context 'when message is nil' do
      it 'raises an exception' do
        error = PubSubRedis::BrokerUnavailable
        expect { subject.process_incoming_data }.to raise_error(error)
      end
    end

    context 'when message is present and block is given' do
      let(:fake_socket) do
        Class.new do
          def initialize(path, port); end

          def gets(*)
            'sample message'.to_json
          end
        end
      end

      it 'yields the given block' do
        block  = ->(arg) { "EXAMPLE: #{arg}" }
        result = 'EXAMPLE: sample message'

        expect(subject.process_incoming_data(&block)).to eq(result)
      end
    end
  end
end
