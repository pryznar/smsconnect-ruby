require 'digest'
require 'securerandom'
require 'net/http'

class Smsconnect

	API_SCRIPT = "http://api.smsbrana.cz/smsconnect/http.php?"

	def initialize(settings)
		@settings = settings
	end

	def salt(length)
		SecureRandom.hex(length)
	end

	def getAuth
		if @settings['login'].nil? && @settings['password'].nil?
			return false
		else
			t = Time.new
			time = t.strftime("%Y%m%d") + "T" + t.strftime("%H%M%S")
			salt = self.salt(10)

			result = {}
			result['login'] = @settings['login']
			result['time'] = time
			result['salt'] = salt
			result['hash'] = Digest::MD5.hexdigest(@settings['password'] + time + salt)

			return result
		end
	end

	def inbox
		data = self.getAuth
		data['action'] = 'inbox'
		data = data.map{|k,v| "#{k}=#{v}"}.join('&')
		url = URI.parse(API_SCRIPT + data)
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) {|http|
		  http.request(req)
		}
		puts res.body
	end

	def send(number, text)
		data = self.getAuth
		data['action'] = 'send_sms'
		data['number'] = number
		data['message'] = text.gsub(/ /, '+')
		data = data.map{|k,v| "#{k}=#{v}"}.join('&')
		url = URI.parse(API_SCRIPT + data)
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) {|http|
		  http.request(req)
		}
		puts res.body
	end
end