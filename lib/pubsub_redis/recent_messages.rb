module PubSubRedis
  # Gets the latest message activity from Redis on the basis of a given
  # subscription message.
  class RecentMessages
    attr_reader :message, :client

    def initialize(message)
      @client  = Redis.new
      @message = message
    end

    def to_h
      messages.map do |key, values|
        values.map { |value| "[#{key}] #{value}" }
      end
    end

    def to_json
      to_h.to_json
    end

    def messages
      message['topics'].inject({}) do |acc, topic|
        acc.merge(topic => Redis.new.lrange(topic, 0, -1))
      end
    end
  end
end
