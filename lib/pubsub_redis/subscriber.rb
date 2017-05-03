module PubSubRedis
  # Once an object of this class is instantiated, it listens for
  # inbound messages from preselected topics and prints them.
  class Subscriber
    attr_reader :path, :topics

    def initialize(path = LocationTuple.new)
      @path   = path
      @topics = []

      yield self if block_given?
    end

    def enroll(new_topic)
      return if topics.include?(new_topic)

      topics << new_topic
    end

    def listen
      client = TCPSocket.new(path.host, path.port)

      client.write({ topics: topics }.to_json)

      puts client.recv(100)
    end
  end
end
