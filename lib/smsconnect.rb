# require 'smsconnect/version'
require 'digest'
require 'securerandom'
require 'net/http'
require 'nokogiri'

module Smsconnect

    class SendResponse
        attr_reader :error, :price, :count, :credit, :sms_id, :plain_xml

        def initialize(err, price, count, credit, sms_id, plain_xml)
            @error = Error.new(err)
            @price = price
            @count = count
            @credit = credit
            @sms_id = sms_id
            @plain_xml = plain_xml
        end

        def is_error?
            @error.is_error?
        end
    end

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
            data = data.map{|k,v| "#{k}=#{v}"}.join('&')
            url = URI.parse(API_SCRIPT + data)
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = url.scheme == 'https'

            req = Net::HTTP::Get.new(url.to_s)
            res = http.start { |http|
                http.request(req)
            }
            res.body
        end
        
        def send(number, text, send_at = nil, delivery_report=nil, sender_id=nil, sender_phone=nil, user_id=nil, data_code=nil, answer_mail=nil, delivery_mail=nil)
            data = self.getAuth
            data['action'] = 'send_sms'
            data['number'] = number
            data['message'] = text.gsub(/ /, '+')
            data['when'] = send_at if send_at
            data['delivery_report'] = delivery_report if delivery_report
            data['sender_id'] = sender_id if sender_id
            data['sender_phone'] = sender_phone if sender_phone
            data['user_id'] = user_id if user_id
            data['data_code'] = data_code if data_code
            data['answer_mail'] = answer_mail if answer_mail
            data['delivery_mail'] = delivery_mail if delivery_mail
            data = data.map { |k,v| "#{k}=#{v}" }.join('&')
            url = URI.parse(API_SCRIPT + data)
            
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = url.scheme == 'https'
            req = Net::HTTP::Get.new(url.to_s)
            res = http.start { |http|
                http.request(req)
            }

            doc = Nokogiri::XML(res.body)
            err = nil
            price = nil
            credit = nil
            sms_count = nil
            sms_id = nil
            doc.xpath('//result').each do |result|
                err = result.at_xpath('err').content
                price = result.at_xpath('price').content if result.at_xpath('price')
                sms_count = result.at_xpath('sms_count').content if result.at_xpath('sms_count')
                credit = result.at_xpath('credit').content if result.at_xpath('credit')
                sms_id = result.at_xpath('sms_id').content if result.at_xpath('sms_id')
            end

            SendResponse.new(err, price, sms_count, credit, sms_id, res.body)
        end
    end
end
