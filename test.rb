require './lib/smsconnect'
require './lib/smsconnect/version'

login = 'test'
password = 'test'

connect = Smsconnect::Smsconnect.new ({'login' => login, 'password' => password})

# result = connect.send('123123123', 'ahoj')
# result = connect.send('+421918123456', 'test')
result = connect.inbox
# result = connect.credit_info

if result.is_error?
	puts "ERROR:"
	puts result.error.message
else
	puts "OK"
	if result.is_a? Smsconnect::CreditResponse
		puts "Credit info: #{result.credit}"
	elsif result.is_a? Smsconnect::SendResponse
		puts "Send response"
		puts " - price #{result.price}"
		puts " - sms_count #{result.count}"
		puts " - credit #{result.credit}"
		puts " - sms_id #{result.sms_id}"
	elsif result.is_a? Smsconnect::InboxResponse
		puts "Inbox response"
		puts " - Delivery SMS"
		puts result.delivery_sms
		puts " - Delivery Report" 
		puts result.delivery_report
	else
		puts "Uknown response"
	end
end
