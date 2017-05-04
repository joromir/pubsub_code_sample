module PubSubRedis
  # :nodoc:
  class Broker
    attr_reader :path, :client

    def initialize(path = LocationTuple.new)
      @path        = path
      @client      = TCPServer.new(path.host, path.port)
      @connections = {}
      @topics      = {}
      @clients     = []

      @connections[:server] = @server
      @connections[:rooms] = @rooms
      @connections[:clients] = @clients
    end

    # TODO: refactor
    def run
      loop do
        Thread.start(@client.accept) do |connection|
          puts 'New connection'

          inbound_message = JSON(connection.recv(1000))
          puts inbound_message.inspect

          if inbound_message['topics']
            @connections[:clients] << connection
            # filter messages on topic basis
            connection.puts %w[recent messages should be shown here].to_json
          else
            clients = @connections[:clients]
            puts clients.inspect

            clients.each do |client|
              client.puts ['asdasda'].to_json
            end
          end
        end
      end
    end
  end
end
