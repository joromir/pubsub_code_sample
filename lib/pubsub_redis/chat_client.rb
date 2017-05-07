module PubSubRedis
  # A sample chat created by the means of this gem.
  # You can start it by: PubSubRedis::ChatClient.new.run
  class ChatClient
    attr_reader :publisher

    def initialize
      @publisher = Publisher.new
    end

    def run
      listen_topic

      loop do
        publisher.execute('topic' => 'cars', 'body' => gets.chomp)
      end
    end

    private

    def listen_topic
      Thread.new do
        PubSubRedis::Subscriber.new do |user|
          user.enroll('cars')
          user.listen { |message| puts "[MESSAGE] : #{message}" }
        end
      end
    end
  end
end
