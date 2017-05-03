# PubSub code sample

## Preliminary requirements

You may want to install `Redis` and run `redis-server` with the default local settings.

## Usage

We will list some concise code samples which should get you up to speed with the solution.

```ruby
publisher = PubSubRedis::Publisher.new
publisher.execute(title: 'titleee', body: 'bodie')
```

```ruby
listener = PubSubRedis::Subscriber.new do |subscriber|
  subscriber.enroll 'cars'
  subscriber.enroll 'money'
  subscriber.enroll 'girls'
end

listener.listen
```
