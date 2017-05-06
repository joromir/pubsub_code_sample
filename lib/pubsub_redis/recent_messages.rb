module PubSubRedis
  # Gets the latest message activity from Redis on the basis of a given
  # subscription message.
  class RecentMessages
    attr_reader :topics, :checker, :message

    def initialize(message, checker = ->(key) { Redis.new.lrange(key, 0, -1) })
      @message = message
      @topics  = message['topics']
      @checker = checker
    end

    def to_a
      topics.map { |topic| beautify(topic) }
    end

    def to_json
      to_a.to_json
    end

    private

    def beautify(topic)
      checker.call(topic).map do |message|
        raw = JSON.parse(message)

        inbound_message = { 'topic' => topic, 'body' => raw['body'] }
        BeautifyMessage.new(raw['timestamp'], inbound_message).to_s
      end
    end
  end
end
