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
    attr_reader :connection, :payload, :broker

    def initialize(connection, broker)
      @connection = connection
      @broker     = broker
      @payload    = JSON.parse(connection.recv(1000))
    end

    def process
      subscribe
      publish
    end

    def publish
      return if subscription?

      timestamp = Time.now.to_i

      History.push(payload, timestamp)

      broker.topics[payload['topic']].each do |subscriber|
        subscriber.puts(BeautifyMessage.new(timestamp, payload).to_s.to_json)
      end
    end

    def subscribe
      return unless subscription?

      payload['topics'].each do |topic|
        broker.add_topic(topic: topic, connection: connection)
      end

      connection.puts(RecentMessages.new(payload).to_json)
    end

    def subscription?
      payload.key?('topics')
    end
  end
end
