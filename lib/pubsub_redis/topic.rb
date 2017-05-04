module PubSubRedis
  class Topic
    attr_reader :connection, :broker

    def initialize(broker, connection)
      @connection = connection
      @broker     = broker
    end

    def execute
      if inbound_message['topics']
        broker.clients << connection
        # get messages from the last 30 minutes from Redis
        # filter messages on topic basis
        connection.puts %w[recent messages should be shown here].to_json
      else
        puts broker.clients.inspect
        TopicFifo.push(inbound_message)
        route_message
      end
    end

    def inbound_message
      @inbound_message ||= JSON(connection.recv(1000))
    end

    private

    def route_message
      broker.clients.each do |client|
        client.puts ['todo: send message'].to_json
      end
    end
  end
end
