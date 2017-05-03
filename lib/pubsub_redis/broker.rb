module PubSubRedis
  # :nodoc:
  class Broker
    def initialize(ip = 'localhost', port = 20_000)
      @ip     = ip
      @port   = port
      @client = TCPServer.new(ip, port)
    end

    def run
      puts 'Broker started! Press ctrl+c to stop.'

      loop do
        Thread.start(client.accept) do |request|
          puts "[#{Time.now}] New message - #{request.inspect}"
          persist(request.recv(1000))
          puts "[#{Time.now}] Completed"
          request.close
        end
      end
    end

    private

    attr_reader :ip, :port, :client

    def persist(message)
      puts message.inspect
      TopicFifo.push(JSON.parse(message))
      # TODO: send to subscribed users.
    end
  end
end
