module PubSubRedis
  # :nodoc:
  class Topic
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

      # get messages from the last 30 minutes from Redis
      # filter messages on topic basis
      connection.puts %w[recent messages should be shown here].to_json
    end

    def publish
      TopicFifo.push(inbound_message)
      route_message
    end

    def route_message
      broker.topics.each do |topic, connections|
        connections.each do |client|
          client.puts [topic, inbound_message].to_json
        end
      end
    end
  end
end
