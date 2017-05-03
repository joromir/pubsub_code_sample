module PubSubRedis
  # :nodoc:
  class Broker
    def initialize(ip = 'localhost', port = 20_000)
      @ip     = ip
      @port   = port
      @client = TCPServer.new(ip, port)
    end

    # TODO: refactor
    def run
      puts 'Broker started! Press ctrl+c to stop.'

      loop do
        Thread.start(client.accept) do |request|
          puts "[#{Time.now}] New message - #{request.inspect}"

          message = JSON(request.recv(1000))
          puts message.inspect

          if message.has_key?('topics')
            recent_messages = TopicFifo.new(message).to_a

            if recent_messages.any?
              recent_messages.each { |message| request.write("#{message}\n") }
            end

          else
            persist(message)
            puts "[#{Time.now}] Connection closed"
            request.close
          end
        end
      end
    end

    private

    attr_reader :ip, :port, :client

    def persist(message)
      TopicFifo.push(JSON.parse(message))
    end
  end
end
