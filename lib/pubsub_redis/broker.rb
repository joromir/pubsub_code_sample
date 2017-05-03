module PubSubRedis
  # :nodoc:
  class Broker
    def initialize(path = LocationTuple.new)
      @path   = path
      @client = TCPServer.new(path.host, path.port)
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

    attr_reader :path, :client

    def persist(message)
      TopicFifo.push(JSON.parse(message))
    end
  end
end
