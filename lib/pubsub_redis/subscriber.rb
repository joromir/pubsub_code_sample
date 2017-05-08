module PubSubRedis
  BrokerUnavailable = Class.new(StandardError)

  # Once an object of this class is instantiated, it listens for
  # inbound messages from preselected topics and prints them.
  class Subscriber
    attr_reader :path, :topics, :client

    def initialize(path = LocationTuple.new, socket = TCPSocket)
      @path   = path
      @topics = []
      @client = socket.new(path.host, path.port)

      yield self if block_given?
    end

    def enroll(new_topic)
      return if topics.include?(new_topic)

      topics << new_topic
    end

    def listen(&block)
      subscribe_to_topics

      loop { process_incoming_data(&block) }
    end

    def to_h
      { topics: topics }
    end

    def process_incoming_data
      message = client.gets

      raise BrokerUnavailable unless message

      output = JSON.parse(message.chomp)
      block_given? ? yield(output) : puts(output)
    end

    private

    def subscribe_to_topics
      client.write(to_h.to_json)
    end
  end
end
