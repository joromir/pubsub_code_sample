require './lib/pubsub_redis'

silent_listener = PubSubRedis::Subscriber.new do |subscriber|
  subscriber.enroll 'money'
end

silent_listener.listen
