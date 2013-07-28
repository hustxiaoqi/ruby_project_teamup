#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/member/member.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}member.rb"
end

module Ash
	module ExtraDB

		class LoginMHelper

			def initialize
				@member_helper = MemberHelper.new
				@member, @db_helper = @member_helper.member, @member_helper.helper
			end

			public
			def find_member_info
				result = @member_helper.find_all_by_email
				return result if result.nil?
				result.member
			end

			def init_member(email)
				@member.email = email
				self
			end

		end
	end
end
