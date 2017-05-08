# PubSub code sample

## About

A code sample app which implements the `pub/sub` model.

## Preliminary requirements

You may want to install `Redis` and run `redis-server` with the default local settings.

## Usage

### Broker

- Run `redis-server`

We need `Redis` for message persistence so each subscriber receives the recent messages from the last 30 minutes on established connection with the broker.

- Two ways to propel the central broker: 
  - `PubSubRedis::Broker.new.run`
  - `bundle exec rake ps:broker`
  
The aforementioned rake task uses the default development configuration - `localhost:20000`.

By default `PubSubRedis::Broker` has a dependency injection of `PubSubRedis::LocationTuple` which evaluates to the tuple `(localhost, 20_000)` if nothing else is mentioned.

### Subscribers

#### Subscripe to particular topics
For the purposes of flexibility, several ways to instantiate a subscriber are possible.

A simple `DSL` is defined for convenience and bulk topic subscription.


```ruby
listener = PubSubRedis::Subscriber.new do |subscriber|
  subscriber.enroll 'cars'
  subscriber.enroll 'money'
  subscriber.enroll 'girls'
end

listener.topics # => ['cars', 'money', 'girls']
```

Single topic can also be subscribed by:
```ruby
listener.enroll('food')

listener.topics # => ['cars', 'money', 'girls', 'food']
```


Duplicative topics get rejected.

```ruby
listener.enroll('grils')

listener.topics # => ['cars', 'money', 'girls', 'food']
```

By default `PubSubRedis::Subscriber` accepts a `PubSubRedis::LocationTuple` which evaluates to `(localhost, 20_000)` if nothing else is mentioned.

#### Listen

Invoke the method `PubSubRedis::Subscriber#listen`

```ruby
listener.listen
```

Now this subscriber is listening from the central broker for new messages. It also gets the recent messages from the last 30 minutes on an established connection.

```ruby
listener.listen do |message|
  # make something with message
  something = 1 + 1
  puts "[#{something}] MODIFIED MESSAGE #{message}"
end
```

#### Sample subscribers

Sample could be executed by the following rake tasks:

- `bundle exec rake ps:subscriber_one`
Subscribed for topics: `cars`, `money`, `girls`

- `bundle exec rake ps:subscriber_two`
Subscribed for topics: `money`

### Publisher

Invoke `PubSubRedis::Publisher#execute` to send messages to the central broker.

```ruby
publisher = PubSubRedis::Publisher.new

publisher.execute(topic: 'money', body: 'lorem ipsum dollor')
```

#### Sample publisher

Sample could be executed by the following rake task:

- `bundle exec rake ps:publisher`
