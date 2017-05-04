module PubSubRedis
  # :nodoc:
  class Broker
    attr_reader :path
    attr_accessor :topics

    def initialize(path = LocationTuple.new)
      @path        = path
      @connections = {}
      @topics      = Hash.new([])
    end

    def run
      puts 'Broker started! Press CTRL+C to stop..'

      server = TCPServer.new(path.host, path.port)

      loop do
        Thread.start(server.accept) do |connection|
          Router.new(self, connection).execute
        end
      end
    end

    def add_topic(topic:, connection:)
      topics.merge!(topic => [connection]) { |_, old, late| old.push(*late) }
    end
  end
end
