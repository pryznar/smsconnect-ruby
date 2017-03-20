# Smsconnect

<img align="right" src="http://www.smsbrana.cz/images/logo.png">

Send and receive SMS with Ruby (for Czech Republic)

[Registration](https://www.smsbrana.cz/registrace.html)

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
puts sms.inbox
```

### Send SMS

simple usage:

```ruby
require 'smsconnect'

sms = Smsconnect::Smsconnect.new({'login'=>'<your_login>', 'password' => '<your_password>'})
puts sms.send('<phone_number>', '<text_sms>')
```

or you can use other optional params:

```ruby
require 'smsconnect'

sms = Smsconnect::Smsconnect.new({'login'=>'<your_login>', 'password' => '<your_password>'})
puts sms.send('<phone_number>', '<text_sms>', '<when>', '<delivery_report>', '<sender_id>', '<sender_phone>', '<user_id>', '<data_code>', '<answer_mail>', '<delivery_mail>')
```

### 


## Contributing

1. Fork it ( https://github.com/pryznar/smsconnect/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
