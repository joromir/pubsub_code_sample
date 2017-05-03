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
      Thread.start(client.accept) do |request|
        persist(request.recv(100))
        puts "Completed #{request}"
        request.close
      end
    end

    def persist(message)
      puts 'received message'
      received_message = JSON.parse(message)
      puts received_message

      TopicFifo.push(received_message)
      # TODO: send to subscribed users.
    end
  end
end
