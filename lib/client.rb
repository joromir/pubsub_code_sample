require 'socket'
require 'json'

module PubSubRedis
  # TODO: delete
  class Client
    attr_reader :ip, :port, :client

    def initialize(ip = 'localhost', port = 20_000)
      @ip     = ip
      @port   = port
      @client = TCPSocket.new(ip, port)
    end

    def execute
      loop do
        @client = TCPSocket.new(ip, port)

        body = gets

        message = { body: body, topic: 'coffee' }

        client.write(message.to_json)
        client.close
      end
    end

    def message
      {
        topic: 'cars',
        message: 'hello'
      }
    end

    def outbound_request
      puts client.recv(100)
      client.write(message.to_json)
      client.close
    end
  end
end

PubSubRedis::Client.new.execute
