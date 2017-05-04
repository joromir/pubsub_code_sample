module PubSubRedis
  # :nodoc:
  class Broker
    attr_reader :path, :client

    def initialize(path = LocationTuple.new)
      @path   = path
      @client = TCPServer.new(path.host, path.port)
      @connections = {}
      @topics = {}
      @clients = []

      @connections[:server] = @server
      @connections[:rooms] = @rooms
      @connections[:clients] = @clients
    end

    # TODO: refactor
    def run
      loop do
        Thread.start(@client.accept) do |connection|
          puts 'New connection'
          @connections[:clients] << connection

          inbound_message = JSON(connection.recv(1000))

          puts inbound_message.inspect

          if inbound_message['topics']
            # filter messages on topic basis
            connection.puts %w[recent messages should be shown here].to_json
          else
            puts 'publisher'
          end

          listen_user_messages(connection)
        end
      end
    end

    def listen_user_messages(client)
      loop do
        message = client.gets.chomp

        @connections[:clients].each do |other_name, other_client|
          other_client.puts message.to_s
        end
      end
    end
  end
end
