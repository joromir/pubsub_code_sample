require 'socket'
require 'json'
require 'redis'
require 'byebug'

require_relative '../lib/pubsub_redis/redis_client'
require_relative '../lib/pubsub_redis/minutes_ago'
require_relative '../lib/pubsub_redis/beautify_message'
require_relative '../lib/pubsub_redis/message_cleaner'
require_relative '../lib/pubsub_redis/history'
require_relative '../lib/pubsub_redis/location_tuple'
require_relative '../lib/pubsub_redis/recent_messages'
require_relative '../lib/pubsub_redis/inbound_message'
require_relative '../lib/pubsub_redis/broker'
require_relative '../lib/pubsub_redis/publisher'
require_relative '../lib/pubsub_redis/subscriber'
require_relative '../lib/pubsub_redis/chat_client'

Thread.abort_on_exception = true
