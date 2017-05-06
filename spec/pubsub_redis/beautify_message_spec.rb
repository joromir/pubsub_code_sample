require 'spec_helper'

RSpec.describe PubSubRedis::BeautifyMessage do
  let(:timestamp) { 1_494_045_961 }

  let(:message) do
    { 'topic' => 'cars', 'body' => 'lorem ipsum' }
  end

  subject { described_class.new(timestamp, message) }

  describe '#to_s' do
    it 'returns an instance of String' do
      expect(subject.to_s).to be_an_instance_of(String)
    end

    it 'formats the message as expected' do
      formated_message = '[cars] 2017-05-06 07:46:01 +0300 : lorem ipsum'
      expect(subject.to_s).to eq formated_message
    end
  end

  describe '#to_json' do
    it 'results the expected json' do
      result = '"[cars] 2017-05-06 07:46:01 +0300 : lorem ipsum"'
      expect(subject.to_json).to eq result
    end
  end
end
