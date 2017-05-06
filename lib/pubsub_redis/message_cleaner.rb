module PubSubRedis
  # Clears old messages that exceed the 30 minutes of existence.
  class MessageCleaner
    include RedisClient
    include MinutesAgo

    attr_reader :topic

    def self.run(topic)
      new(topic).run
    end

    def initialize(topic)
      @topic = topic
    end

    def run
      history = []
      history << client.lpop(topic) while client.lrange(topic, 0, -1).any?

      history.each do |element|
        next unless expired?(JSON.parse(element)['timestamp'])
        client.lpush(topic, element)
      end
    end
  end
end
