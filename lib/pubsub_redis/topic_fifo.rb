module PubSubRedis
  # :nodoc:
  class TopicFifo
    attr_reader :topic, :body

    def self.push(message)
      new(message).push
    end

    def initialize(message)
      @topic = message.fetch('topic')
      @body  = message.fetch('body')
    end

    def push
      client.lpush(topic, body)
    end

    def to_a
      client.lrange(topic, 0, -1)
    end

    private

    def client
      @client ||= Redis.new
    end
  end
end
