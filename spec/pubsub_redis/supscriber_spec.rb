require 'spec_helper'

RSpec.describe PubSubRedis::Subscriber do
  describe '#enroll' do
    subject { described_class.new }

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
end
