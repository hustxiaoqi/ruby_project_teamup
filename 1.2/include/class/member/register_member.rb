#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'digest'
require 'securerandom'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/member/member.rb"
	require "#{MAIN_PATH}include/config/common_config.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}member.rb"
end

module Ash
	module ExtraDB

		class RegisterMHelper

			def initialize
				@member_helper = MemberHelper.new
				@member, @db_helper = @member_helper.member, @member_helper.helper
			end

			public
			def init_member(email, pwd = '')
				@member.email, @member.password = email, pwd
				self
			end

			def exist_email?
				!@db_helper.find_one({email: @member.email}).nil?
			end

			def insert_briefs
				uuid = Digest::SHA1.hexdigest(SecureRandom.uuid)
				id = @db_helper.insert({briefIntroduction: '', email: @member.email, isActive: Disposition::COMMON_NOT_ACTIVE.to_s, isForzen: Disposition::COMMON_FORZEN.to_s, memberName: '', memberProfile: '', memberUUId: uuid, participatingTeams: [], passwordMD5: Digest::MD5.hexdigest(@member.email), registeredTime: Time.now.to_i.to_s, verifyTime: ''})
				id.nil? and return
				Struct.new(:id, :uuid).new(id.to_s, uuid)
			end

			def update_teams(uid, tid)
				@db_helper.update({_id: BSON::ObjectId(uid)}, {"$push" => {participatingTeams: {teamId: tid, teamAuthority: Disposition::COMMON_TEAM_CREATE_AUTHORITY.to_s, teamJoinTime: Time.now.to_i.to_s, teamQuitTime: '', beingUsed: Disposition::COMMON_BEING_USED.to_s}}})['updatedExisting']
			end

		end
	end
end
