module PubSubRedis
  # Central message broker which relies on Redis for
  # message persistence. Make sure redis-server is
  # started to ensure everything works as expected.
  class Broker
    include RedisClient

    attr_reader :path
    attr_accessor :topics

    def initialize(path = LocationTuple.new)
      @path        = path
      @topics      = {}
    end

    def run
      puts 'Broker started! Press CTRL+C to stop..'
      server = TCPServer.new(path.host, path.port)

      client.ping

      loop do
        Thread.start(server.accept) do |connection|
          InboundMessage.new(connection, self).process
        end
      end
    end

    def add_topics(topics:, connection:)
      topics.each { |topic| add_topic(topic: topic, connection: connection) }
    end

    def add_topic(topic:, connection:)
      MessageCleaner.run(topic)

      topics.merge!(topic => [connection]) { |_, old, late| old.push(*late) }
    end
  end
end
