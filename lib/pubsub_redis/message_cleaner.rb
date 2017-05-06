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
      initial = next_element
      element = next_element

      while !element.nil? && element != initial
        puts initial.inspect
        puts element.inspect

        insert_element(topic, element) unless expired?(timestamp(element))
        element = next_element
      end

      insert_element(topic, initial)
    end

    private

    def timestamp(element)
      JSON.parse(element)['timestamp']
    end

    def insert_element(topic, element)
      client.lpush(topic, element)
    end

    def next_element
      client.rpop(topic)
    end
  end
end
