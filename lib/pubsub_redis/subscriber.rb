module PubSubRedis
  # :nodoc:
  class Subscriber
    attr_reader :ip, :port, :topics

    def initialize(ip = 'localhost', port = 20_000)
      @ip   = ip
      @port = port
      @topics = []

      yield self if block_given?
    end

    def enroll(new_topic)
      return if topics.include?(new_topic)

      topics << new_topic
    end

    def listen
      client = TCPSocket.new('localhost', 20_000)

      client.write({ topics: topics }.to_json)

      puts client.recv(100)
    end
  end
end
