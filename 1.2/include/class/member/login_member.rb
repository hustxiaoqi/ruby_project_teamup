#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'digest'

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
			def verify_member
				result = @member_helper.find_all_by_email
				result.member if !result.nil? and result.member.password == @member.password
			end

			def init_member(email, pwd)
				@member.email, @member.password = email, Digest::MD5.hexdigest(pwd)
				self
			end

		end
	end
end
