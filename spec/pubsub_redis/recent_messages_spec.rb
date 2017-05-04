require 'spec_helper'

RSpec.describe PubSubRedis::RecentMessages do
  subject { described_class.new(message) }

  describe '#to_a' do
    context 'when topics are empty' do
      let(:message) { { topics: [] } }

      it 'is an instance of Hash' do
        expect(subject.to_a).to be_an_instance_of(Array)
      end

      it 'results the expected array' do
        expect(subject.to_a).to eq []
      end
    end
  end
end
