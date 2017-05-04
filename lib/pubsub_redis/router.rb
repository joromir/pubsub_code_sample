module PubSubRedis
  # Routes inbound messages - messages from publishers or
  # the ones which by subscribers enroll a given topic.
  class Router
    attr_reader :connection, :broker

    def initialize(broker, connection)
      @connection = connection
      @broker     = broker
    end

    def execute
      message.subscribe
      message.publish
    end

    private

    def message
      @message ||= InboundMessage.new(connection, broker)
    end
  end
end
