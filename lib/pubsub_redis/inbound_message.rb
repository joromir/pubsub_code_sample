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

      TopicFifo.push(payload)
      message_topic = payload['topic']

      broker.topics[message_topic].each do |subscriber|
        subscriber.puts("[#{message_topic}] #{payload['body']}".to_json)
      end
    end

    def subscribe
      return unless subscription?

      join_topics
      connection.puts(fetch_recent_messages.to_json)
    end

    def subscription?
      payload.key?('topics')
    end

    private

    def fetch_recent_messages
      messages = payload['topics'].inject({}) do |acc, topic|
        acc.merge(topic => Redis.new.lrange(topic, 0, -1))
      end

      messages.map do |key, values|
        values.map { |value| "[#{key}] #{value}" }
      end
    end

    def join_topics
      payload['topics'].each do |topic|
        broker.add_topic(topic: topic, connection: connection)
      end
    end
  end
end
