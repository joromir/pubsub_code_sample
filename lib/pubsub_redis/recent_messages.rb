module PubSubRedis
  # Gets the latest message activity from Redis on the basis of a given
  # subscription message.
  class RecentMessages
    include RedisClient

    attr_reader :message, :checker

    def initialize(message, checker = ->(key) { Redis.new.lrange(key, 0, -1) })
      @message = message
      @checker = checker
    end

    def to_a
      messages.map do |key, values|
        values.map { |value| "[#{key}] #{value}" }
      end
    end

    def to_json
      to_a.to_json
    end

    private

    def messages
      message['topics'].reduce({}) do |acc, topic|
        acc.merge(topic => checker.call(topic))
      end
    end
  end
end
