module PubSubRedis
  # Converts message into a human-readable format.
  class BeautifyMessage
    attr_reader :topic, :body, :time

    def initialize(timestamp, inbound_message)
      @topic, @body = inbound_message.values_at('topic', 'body')

      @time = Time.at(timestamp)
    end

    def to_s
      "[#{topic}] #{time} : #{body}"
    end
  end
end
