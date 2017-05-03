module PubSubRedis
  class Broker
    attr_reader :ip, :port, :client

    def initialize(ip = 'localhost', port = 20_000)
      @ip     = ip
      @port   = port
      @client = TCPServer.new(ip, port)
    end

    def run
      puts 'Broker started!'

      loop { handle_inbound_request }
    end

    private

    def handle_inbound_request
      Thread.start(client.accept) do |s|
        persist(s.recv(100))
        puts "Completed #{s}"
        s.close
      end
    end

    def persist(message)
      puts 'received message'
      received_message = JSON.parse(message)
      puts received_message
      # TODO: store in redis and send to
      # subscribed users.

      client = Redis.new
      client.lpush(received_message['title'], received_message['body'])
    end
  end
end
