module PubSubRedis
  # A sample chat created by the means of this gem.
  # You can start it by: PubSubRedis::ChatClient.new.run
  class ChatClient
    attr_reader :publisher

    def initialize
      @publisher = PubSubRedis::Publisher.new
    end

    def run
      listen_topic

      loop do
        publisher.execute('topic' => 'chat', 'body' => STDIN.gets.chomp)
      end
    end

    private

    def listen_topic
      Thread.new do
        PubSubRedis::Subscriber.new do |user|
          user.enroll('chat')
          user.listen
        end
      end
    end
  end
end
