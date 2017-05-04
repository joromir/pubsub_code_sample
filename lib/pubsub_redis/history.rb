module PubSubRedis
  # Used for message persistence. Keeps published messages for upto 30 minutes
  # so newly connected users could join the communication.
  class History
    include RedisClient

    attr_reader :topic, :body, :timestamp

    def self.push(message)
      new(message).push
    end

    def initialize(message)
      @topic, @body = message.values_at('topic', 'body')

      @timestamp = Time.now.to_i
    end

    def push
      client.lpush(topic, timestamp_body.to_json)
    end

    private

    def timestamp_body
      { body: body, timestamp: timestamp }
    end
  end
end
