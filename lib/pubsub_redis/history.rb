module PubSubRedis
  # Used for message persistence. Keeps published messages for upto 30 minutes
  # so newly connected users could join the communication.
  class History
    attr_reader :topic, :body, :client

    def self.push(message)
      new(message).push
    end

    def initialize(message)
      @client = Redis.new

      @topic, @body = message.values_at('topic', 'body')
    end

    def push
      client.lpush(topic, body)
    end
  end
end
