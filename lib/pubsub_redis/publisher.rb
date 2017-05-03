module PubSubRedis
  # :nodoc:
  class Publisher
    def initialize(host = 'localhost', port = 20_000)
      @host = host
      @port = port
    end

    def execute(message)
      client = TCPSocket.new(host, port)

      client.write(message.to_json)
      client.close
    end

    private

    attr_reader :host, :port
  end
end
