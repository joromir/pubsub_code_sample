require './lib/pubsub_redis'

silent_listener = PubSubRedis::Subscriber.new do |subscriber|
  subscriber.enroll 'cars'
  subscriber.enroll 'money'
  subscriber.enroll 'girls'
end

silent_listener.enroll 'girls'
silent_listener.enroll 'girls'

silent_listener.listen
