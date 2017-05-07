require 'spec_helper'

RSpec.describe PubSubRedis::Publisher do
  describe '#path' do
    it 'responds to path' do
      expect(subject).to respond_to :path
    end
  end
end
