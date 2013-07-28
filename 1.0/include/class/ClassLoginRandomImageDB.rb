#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

module Ash
	module ExtraDB

		class CRandomImageHelper

			def initialize
				@helper = Ash::DB::CDBHelper.new('loginRandomImage')
			end

			public
			def insert(email, start_time, text, path)
				@helper.insert({:email => email, :startTime => start_time, :token => text, :path => path})
				self
			end

			def find_by_email(email)
				final, result = {}, @helper.find_one({:email => email}, 'startTime', 'token', 'path')
				return result if result == nil
				final['start_time'], final['old_token'], final['image_path'] = result['startTime'], result['token'], result['path']
				final
			end

			def remove_by_email(email)
				@helper.remove({:email => email})
				self
		 	end
		end
	end
end
