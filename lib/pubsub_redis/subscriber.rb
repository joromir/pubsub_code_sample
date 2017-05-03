module PubSubRedis
  # :nodoc:
  class Subscriber
    def initialize(ip = 'localhost', port = 20_000)
      @ip   = ip
      @port = port
      @topics = []

      yield self
    end

    def enroll(new_topic)
      return if topics.include?(new_topic)

      topics << new_topic
    end

    def listen
      client = TCPSocket.new('localhost', 20_000)

      puts client.recv(100)
    end

    private

    attr_reader :ip, :port, :topics
  end
end
