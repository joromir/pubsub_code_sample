module PubSubRedis
  # :nodoc:
  class Publisher
    def initialize(path = LocationTuple.new)
      @path = path
    end

    def execute(message)
      client = TCPSocket.new(path.host, path.port)

      client.write(message.to_json)
      client.close
    end

    private

    attr_reader :path
  end
end
