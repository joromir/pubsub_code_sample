module PubSubRedis
  # :nodoc:
  class Broker
    attr_reader :path
    attr_accessor :clients

    def initialize(path = LocationTuple.new)
      @path        = path
      @connections = {}
      @topics      = {}
      @clients     = []
    end

    def run
      server = TCPServer.new(path.host, path.port)

      loop do
        Thread.start(server.accept) do |connection|
          Topic.new(self, connection).execute
        end
      end
    end
  end
end
