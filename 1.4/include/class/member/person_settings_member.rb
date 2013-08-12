#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/member/member.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}member.rb"
end

module Ash
	module ExtraDB

		class PersonSMHelper

			def initialize
				@member_helper = MemberHelper.new
				@member, @db_helper = @member_helper.member, @member_helper.helper
			end

			public
			def init_member(uid, name, brief)
				@member.id, @member.name, @member.introduction = uid, name, brief
				self
			end

			def update_member_brief
				@db_helper.update({_id: BSON::ObjectId(@member.id)}, {"$set" => {briefIntroduction: @member.introduction, memberName: @member.name}})['updatedExisting']
			end

			def find_member_profile(id)
				result = @db_helper.find_one({_id: BSON::ObjectId(id)}, 'memberProfile')
				return result if result.nil?
				result['memberProfile']
			end

			def find_member_briefs(uid)
				@member.id = uid
				result = @member_helper.find_all_by_uid
				return result if result.nil?
				[result.member.name, result.member.introduction, result.member.profile]
			end

			def update_member_profile(uid, profile)
				@db_helper.update({_id: BSON::ObjectId(uid)}, {"$set" => {memberProfile: profile}})['updatedExisting']
			end

			def update_member_pwd(uid, pwd)
				@db_helper.update({_id: BSON::ObjectId(uid)}, {"$set" => {passwordMD5: Digest::MD5.hexdigest(pwd)}})['updatedExisting']
			end

			def password?(uid, pwd)
				result = @db_helper.find_one({_id: BSON::ObjectId(uid)}, 'passwordMD5')
				pp result
				raise RuntimeError, "Uid Not Exisst" if result.nil?
				pwd == result['passwordMD5']
			end

		end
	end
end
