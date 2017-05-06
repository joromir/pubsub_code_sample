module PubSubRedis
  # Clears old messages that exceed the 30 minutes of existence.
  class MessageCleaner
    include RedisClient
    include MinutesAgo

    attr_reader :topic, :history

    def self.run(topic)
      new(topic).run
    end

    def initialize(topic)
      @topic = topic
      @history = []
    end

    def run
      @history << client.lpop(topic) while redis_messages.any?

      history.each do |element|
        next unless expired?(timestamp(element))
        client.lpush(topic, element)
      end
    end

    private

    def redis_messages
      client.lrange(topic, 0, -1)
    end
  end
end
