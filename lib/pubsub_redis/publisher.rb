module PubSubRedis
  # :nodoc:
  class Publisher
    def initialize(ip = 'localhost', port = 20_000)
      @ip   = ip
      @port = port
    end

    def execute(message)
      client = TCPSocket.new(ip, port)

      client.write(message.to_json)
      client.close
    end

    private

    attr_reader :ip, :port
  end
end
