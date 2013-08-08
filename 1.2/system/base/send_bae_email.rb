#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'uri'
require 'net/http'
require 'digest'
require 'json'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/config/common_config.rb"
end

module Ash
	module Utils

		class SendBaeEmail

			attr_accessor :message, :subject

			@@token = Digest::SHA1.hexdigest(Disposition::COMMON_BAE_EMAIL_TOKEN)

			def initialize(args = {})
				args.instance_of?(Hash) or raise SendBaeEmailException, "SendBaeEmail argument error"
				args.map {|key, value| self.instance_variable_set("@#{key}", value)} unless args.empty?
			end

			def format_message
				'<!--HTML-->' + @message
			end

			def address
				@address
			end

			def address=(addr)
				@address ||= []
				@address << addr
			end

			def send
				uri = URI.parse(Disposition::COMMON_BAE_EMAIL_URI)
				request_body = {
					'address' => @address.to_json,
					'message' => self.format_message,
					'mail_subject' => @subject,
					'token' => @@token,
				}
				result = Net::HTTP.post_form(uri, request_body)
				JSON.parse(result.body)['status']
			end
		end

		class SendBaeEmailException < StandardError; end
	end
end
