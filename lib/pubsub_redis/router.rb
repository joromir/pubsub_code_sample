module PubSubRedis
  # :nodoc:
  class Router
    attr_reader :connection, :broker

    def initialize(broker, connection)
      @connection = connection
      @broker     = broker
    end

    def execute
      inbound_message['topics'] ? subscribe : publish
    end

    def inbound_message
      @inbound_message ||= JSON(connection.recv(1000))
    end

    private

    def populate_subscribers
      inbound_message['topics'].each do |topic|
        broker.topics[topic] = broker.topics[topic] + [connection]
      end
    end

    def subscribe
      populate_subscribers
      puts broker.topics.inspect

      recent_messages = inbound_message['topics'].inject({}) do |acc, elem|
        acc.merge(elem => TopicFifo.new(topic: elem).to_a)
      end

      connection.puts recent_messages.to_json
    end

    def publish
      TopicFifo.push(inbound_message)
      subscribers = broker.topics[inbound_message['topic']]

      subscribers.each { |subscriber| subscriber.puts(inbound_message.to_json) }
    end
  end
end
