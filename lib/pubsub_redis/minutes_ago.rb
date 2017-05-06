module PubSubRedis
  module MinutesAgo
    def minutes_ago(minutes)
      Time.now - (minutes * 60)
    end

    def expired?(timestamp)
      minutes_ago(30) < Time.at(timestamp)
    end
  end
end
