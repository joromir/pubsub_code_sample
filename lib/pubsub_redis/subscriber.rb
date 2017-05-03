module PubSubRedis
  # :nodoc:
  class Subscriber
    attr_reader :host, :port, :topics

    def initialize(host = 'localhost', port = 20_000)
      @host   = host
      @port   = port
      @topics = []

      yield self if block_given?
    end

    def enroll(new_topic)
      return if topics.include?(new_topic)

      topics << new_topic
    end

    def listen
      client = TCPSocket.new(host, port)

      client.write({ topics: topics }.to_json)

      puts client.recv(100)
    end
  end
end
