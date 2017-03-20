require 'smsconnect/version'
require 'digest'
require 'securerandom'
require 'net/http'

module Smsconnect
    class Smsconnect
        
        API_SCRIPT = "https://api.smsbrana.cz/smsconnect/http.php?"
        
        def initialize(settings)
            @settings = settings
        end
        
        def salt(length)
            SecureRandom.hex(length)
        end
        
        def getAuth
            return false if @settings['login'].nil? && @settings['password'].nil?
                
            t = Time.new
            time = t.strftime("%Y%m%d") + "T" + t.strftime("%H%M%S")
            salt = self.salt(10)
            
            result = {}
            result['login'] = @settings['login']
            result['time'] = time
            result['salt'] = salt
            result['hash'] = Digest::MD5.hexdigest(@settings['password'] + time + salt)
            
            result
        end
        
        def inbox
            data = self.getAuth
            data['action'] = 'inbox'
            data = data.map{ |k,v| "#{k}=#{v}" }.join('&')
            url = URI.parse(API_SCRIPT + data)
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = url.scheme == 'https'
            req = Net::HTTP::Get.new(url.to_s)
            res = http.start { |http|
                http.request(req)
            }
            res.body
        end
        
        def send(number, text)
            data = self.getAuth
            data['action'] = 'send_sms'
            data['number'] = number
            data['message'] = text.gsub(/ /, '+')
            data = data.map{ |k,v| "#{k}=#{v}" }.join('&')
            url = URI.parse(API_SCRIPT + data)
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = url.scheme == 'https'
            req = Net::HTTP::Get.new(url.to_s)
            res = http.start { |http|
                http.request(req)
            }
            res.body
        end
    end
end
