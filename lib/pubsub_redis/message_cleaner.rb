module PubSubRedis
  # Clears old messages that exceed the 30 minutes of existence.
  class MessageCleaner
    include RedisClient
    include MinutesAgo

    attr_reader :topic

    def self.run(topic)
      new(topic).run
    end

    def initialize(topic)
      @topic = topic
    end

    def run
      initial = extract_element
      element = extract_element

      until element != initial
        timestamp = JSON.parse(element)['timestamp']

        insert_element(topic, element) unless expired?(timestamp)
        element = extract_element
      end
    end

    private

    def insert_element(topic, element)
      client.lpush(topic, element)
    end

    def extract_element
      client.rpop(topic)
    end
  end
end
