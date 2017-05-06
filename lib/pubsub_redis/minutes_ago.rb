module PubSubRedis
  # :nodoc:
  module MinutesAgo
    def minutes_ago(minutes)
      Time.now - (minutes * 60)
    end

    def expired?(timestamp)
      minutes_ago(30) < Time.at(timestamp)
    end

    def timestamp(element)
      JSON.parse(element)['timestamp']
    end
  end
end
