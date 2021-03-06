module PubSubRedis
  # A container for host, port pair
  class LocationTuple
    attr_reader :host, :port

    def initialize(host: 'localhost', port: 20_000)
      @host = host
      @port = port
    end
  end
end
