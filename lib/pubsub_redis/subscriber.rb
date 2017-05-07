module PubSubRedis
  BrokerUnavailable = Class.new(StandardError)

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

      loop do
        message = client.gets

        raise BrokerUnavailable unless message

        puts JSON.parse(message.chomp)
      end
    end

    def to_h
      { topics: topics }
    end

    private

    def subscribe_to_topics
      client.write(to_h.to_json)
    end

    def client
      @client ||= TCPSocket.new(path.host, path.port)
    end
  end
end
