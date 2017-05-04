require './lib/pubsub_redis'

namespace :ps do
  task :broker do
    puts 'Broker started on default settings'
    puts 'localhost:20000'

    PubSubRedis::Broker.new.run
  end

  task :subscriber_one do
    puts 'sample subscriber one'
    puts "TOPICS: 'cars', 'money', 'girls'"

    listener = PubSubRedis::Subscriber.new do |subscriber|
      subscriber.enroll 'cars'
      subscriber.enroll 'money'
      subscriber.enroll 'girls'
    end

    listener.listen
  end

  task :subscriber_two do
    puts 'sample subscriber two'
    puts "TOPICS: 'money'"

    listener = PubSubRedis::Subscriber.new
    listener.enroll 'money'
    listener.listen
  end

  task :publisher do
    puts 'sample Publisher'

    PubSubRedis::Publisher.new.execute(topic: 'money', body: 'money, money, money')
    PubSubRedis::Publisher.new.execute(topic: 'cars', body: 'I like cars!!')
  end
end
