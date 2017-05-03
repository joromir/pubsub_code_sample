module PubSubRedis
  # :nodoc:
  class Subscriber
    attr_reader :ip, :port, :topics

    def initialize(ip = 'localhost', port = 20_000)
      @ip   = ip
      @port = port
      @topics = []

      yield self
    end

    def enroll(new_topic)
      topics << new_topic
    end

    def listen; end
  end
end
