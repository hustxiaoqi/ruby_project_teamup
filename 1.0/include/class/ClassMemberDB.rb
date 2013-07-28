#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'digest'
require 'pp'

module Ash
	module ExtraDB

		class CMemberHelper

			def initialize
				@helper = Ash::DB::CDBHelper.new('member')
			end

			public
			def find_by_email(email)
			 final, result = {}, @helper.find_one({email: email}, 'partyName', 'passwordMD5', 'authPermission', 'isActive')
			 return result if result == nil
			 final[:password], final[:party_name], final[:uid], final[:permission], final[:active] = result['passwordMD5'], result['partyName'], result['_id'].to_s, result['authPermission'], result['isActive']
			 final
			end

			def find_by_id(id, *query); @helper.find_one({_id: BSON::ObjectId(id)},*query); end

			def email?(email)
				@helper.find_one({email: email}) != nil
			end

			def insert_member(party_name, email, pwd, token, time)
				@helper.insert({partyName: party_name, email: email, passwordMD5: Digest::MD5.hexdigest(pwd), isActive: 0, authPermission: 1, uuidToken: token, startTime: time, verifyTime: ''}).to_s
			end

			#Return
			#  Type 1 ==> Email Do Not Exist
			#  Type 2 ==> Token Over Time
			#  Type 0 ==> Success
			def find_onverify_email(email, token)
				result = @helper.find_one({email: email, isActive: 0, uuidToken: token}, 'startTime')
				return {type: 1, status: false} if result == nil
				time_diff = (Time.now.to_i - result['startTime'].to_i)
				return {type:2, status: false} unless time_diff > 0 and time_diff < Ash::Disposition::COMMON_EMAIL_TOKEN_EXPIRES
				{type: 0, status: true}
			end

			def update_onverify_info(email, token)
				@helper.update({email: email, uuidToken: token, isActive: 0}, "$set" => {isActive: Ash::Disposition::COMMON_PARTY_ACTIVE, verifyTime: Time.now.to_i.to_s})
			end


		end
	end
end
