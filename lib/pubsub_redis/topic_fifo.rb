module PubSubRedis
  class TopicFifo
    attr_reader :topic, :body

    def self.push(message)
      new(message).push
    end

    def initialize(message)
      @topic = message['title']
      @body  = message['body']
    end

    def push
      client.lpush(topic, body)
    end

    private

    def client
      @client ||= Redis.new
    end
  end
end
