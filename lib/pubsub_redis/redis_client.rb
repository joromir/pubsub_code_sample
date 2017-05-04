module PubSubRedis
  # :nodoc:
  module RedisClient
    def client
      @client ||= Redis.new
    end
  end
end
