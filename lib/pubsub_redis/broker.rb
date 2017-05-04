module PubSubRedis
  # :nodoc:
  class Broker
    attr_reader :path
    attr_reader :server

    attr_accessor :clients

    def initialize(path = LocationTuple.new)
      @path        = path
      @server      = TCPServer.new(path.host, path.port)
      @connections = {}
      @topics      = {}
      @clients     = []
    end

    def run
      loop do
        Thread.start(server.accept) do |connection|
          Topic.new(self, connection).execute
        end
      end
    end
  end
end
