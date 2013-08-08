#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'digest'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/member/member.rb"
	require "#{MAIN_PATH}include/config/common_config.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}member.rb"
end

module Ash
	module ExtraDB

		class LoginMHelper

			attr_reader :member

			def initialize
				@member_helper = MemberHelper.new
				@member, @db_helper = @member_helper.member, @member_helper.helper
			end

			public
			def verify_member
				result = @member_helper.find_all_by_email
				result.member if !result.nil? and result.member.password == @member.password
			end

			def init_member(args)
				args.map {|key, value| @member.instance_variable_set("@#{key}", value)}
				self
			end

			def verify_email
				result = @member_helper.find_all_by_email
				result.nil? and return
				Struct.new(:active, :frozen, :uuid).new(result.member.active == Disposition::COMMON_ACTIVE.to_s, result.member.frozen == Disposition::COMMON_FROZEN.to_s, result.member.uuid)
			end

			def update_reset_time
				@db_helper.update({email: @member.email}, {"$set" => {resetPwdTime: Time.now.to_i.to_s}})['updatedExisting']
			end
			
			def verify_reset_time
				result = @db_helper.find_one({memberUUId: @member.uuid}, 'resetPwdTime', 'passwordMD5')
				result.nil? and return
				reset_time = result['resetPwdTime'].to_i
				reset_status = reset_time > 0 and reset_time < Disposition::COMMON_RESET_PWD_TIME
				Struct.new(:overtime, :password).new(!reset_status, result['passwordMD5'] == @member.password)
			end

			def update_pwd
				@db_helper.update({memberUUId: @member.uuid}, {"$set" => {passwordMD5: @member.password}})['updatedExisting']
			end

		end
	end
end
