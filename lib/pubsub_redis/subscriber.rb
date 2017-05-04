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
      subscribe_to_topics

      loop { puts JSON(client.gets.chomp) }
    end

    private

    def subscribe_to_topics
      client.write({ topics: topics }.to_json)
    end

    def client
      @client ||= TCPSocket.new(path.host, path.port)
    end
  end
end
