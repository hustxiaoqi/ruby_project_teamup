#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

module Ash
	module ExtraDB

		class LoginRImgHelper

			def initialize(email)
				@helper = Ash::DB::DBHelper.new('LoginRandomImage')
				@email = email
			end

			public
			def insert(start_time, text, path)
				@helper.insert({:email => @email, :startTime => start_time, :token => text, :path => path})
				self
			end

			def find_by_email
				result = @helper.find_one({:email => @email}, 'startTime', 'token', 'path')
				result == nil and return
				Struct.new(:time, :token, :path).new(result['startTime'], result['token'], result['path'])
			end

			def remove_by_email
				@helper.remove({:email => @email})
				self
		 	end
		end
	end
end
