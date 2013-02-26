# Nexmos [![Build Status](https://travis-ci.org/phenomena/nexmos.png)](https://travis-ci.org/phenomena/nexmos)

Nexmo API wrapper

## Installation

Add this line to your application's Gemfile:

    gem 'nexmos'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nexmos

## Usage

### Send text message

```ruby
# Nexmos specific client
client = ::Nexmos::Message.new('api-key', 'api-secret')
# get result from Nexmo
res = client.send_text(from: 'your number', to: '+1234567890', text: 'Hello world!')
# check if send is success
if res.success?
  puts "ok"
else
  puts "fail"
end
```

### Get balance

```ruby
client = ::Nexmos::Account.new('api-key', 'api-secret')
res = client.get_balance
my_balance = res.value
```

## Rails integration

You can create `config/initializer/nexmos.rb` file with next content:

```ruby
Nexmos.setup do |n|
  n.api_key    = 'api_key'
  n.api_secret = 'api_secret'
end
```

And then you can call all clients without providing key and secret.

## More details about api calls

More details about api calls you can found in the lib/api.yml file.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
