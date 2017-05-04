module PubSubRedis
  # This class holds the responsibility of message sending to the central
  # Broker. Message payload is expected to have topic and body as attributes.
  class Publisher
    attr_reader :path

    def initialize(path = LocationTuple.new)
      @path = path
    end

    def execute(message)
      client = TCPSocket.new(path.host, path.port)

      client.write(message.to_json)
      client.close
    end
  end
end
