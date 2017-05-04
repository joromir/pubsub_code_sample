require 'simplecov'

SimpleCov.start do
  add_group 'PubSubRedis', './lib/pubsub_redis'
  add_filter './spec/*'
end

require './lib/pubsub_redis'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
