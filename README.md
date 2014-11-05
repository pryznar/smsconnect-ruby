# Smsconnect

<img align="right" src="http://www.smsbrana.cz/images/logo.png">

Send and receive SMS with node.js (for Czech Republic)

[Registration](http://www.smsbrana.cz/registrace.html)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smsconnect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smsconnect

## Usage

### Inbox

```ruby
require 'smsconnect'

sms = Smsconnect::Smsconnect.new({'login'=>'<your_login>', 'password' => '<your_password>'})
sms.inbox
```

### Send SMS

```ruby
require 'smsconnect'

sms = Smsconnect::Smsconnect.new({'login'=>'<your_login>', 'password' => '<your_password>'})
sms.send('<phone_number>', '<text_sms>')
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/smsconnect/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
