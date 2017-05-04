module PubSubRedis
  # Gets the latest message activity from Redis on the basis of a given
  # subscription message.
  class RecentMessages
    include RedisClient

    attr_reader :message

    def initialize(message)
      @message = message
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
      return [] unless message.key?('topics')

      message['topics'].reduce({}) do |acc, topic|
        acc.merge(topic => Redis.new.lrange(topic, 0, -1))
      end
    end
  end
end
