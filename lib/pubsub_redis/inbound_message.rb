module PubSubRedis
  # This piece of code follows the 'tell, dont ask principle' and behaves
  # depending on the message payload. The expected payload is either a
  # subscription message or it is a publisher message that should be
  # broadcasted to a given topic.
  #
  # Subscription message is expected like this:
  #
  # { topics: ['cars', 'girls', 'money'] }
  #
  # ..and publisher message looks like this:
  #
  # {
  #   topic: 'cars',
  #   body: 'Big red cars are the ones that I like'
  # }
  class InboundMessage
    attr_reader :connection, :broker, :payload, :timestamp

    def initialize(connection, broker)
      @connection = connection
      @broker     = broker
      @payload    = JSON.parse(connection.recv(1000))
      @timestamp  = Time.now.to_i
    end

    def process
      subscribe
      publish
    end

    def publish
      return if subscription?

      History.push(payload, timestamp)
      distribute_message
    end

    def subscribe
      return unless subscription?

      broker.add_topics(topics: payload['topics'], connection: connection)

      RecentMessages.new(payload).send_activity(connection)
    end

    def subscription?
      payload.key?('topics')
    end

    private

    def distribute_message
      broker.topics[payload['topic']].each do |subscriber|
        subscriber.puts(BeautifyMessage.new(timestamp, payload).to_json)
      end
    end
  end
end
