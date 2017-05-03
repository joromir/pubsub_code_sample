module PubSubRedis
  class Publisher
    attr_reader :ip, :port

    def initialize(ip = 'localhost', port = 20_000)
      @ip   = ip
      @port = port
    end

    def execute(message)
      client = TCPSocket.new(ip, port)

      client.write(message.to_json)
      client.close
    end
  end
end
