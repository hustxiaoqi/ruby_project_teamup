#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/BaseMembersDB.rb"
	require "#{MAIN_PATH}include/config/ConfigCommon.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}BaseMembersDB.rb"
end

module Ash
	module ExtraDB

		class CRegisterMembersHelper < Ash::ExtraDB::CBaseMembersHelper

			public
			def email?(email); @helper.find_one({email: email}) != nil; end

			def insert_brief_member(email, pwd, time)
				self.insert_detailed_member(email, pwd, time)
			end

			def update_member_teams(uid, team_id)
				team = {teamId: team_id, teamAuthority: Ash::Disposition::COMMON_TEAM_CREATE_AUTHORITY, teamJoinTime: Time.now.to_i.to_s, teamQuitTime: '', beingUsed: Ash::Disposition::COMMON_ACTIVE.to_s}
				result = @helper.update({_id: BSON::ObjectId(uid)}, "$push" => {participatingTeams: team})
				result['updatedExisting']
			end

			#Return
			#  Type 1 ==> Email Do Not Exist
			#  Type 2 ==> Token Over Time
			#  Type 0 ==> Success
			def find_onverify_email(email, token)
				result = @helper.find_one({email: email, isActive: 0, memberUUId: token}, 'registeredTime')
				return {type: 1, status: false} if result == nil
				time_diff = Time.now.to_i - result['registeredTime'].to_i
				return {type:2, status: false} unless time_diff > 0 and time_diff < Ash::Disposition::COMMON_EMAIL_TOKEN_EXPIRES
				{type: 0, status: true}
			end

			def update_onverify_info(email, token)
				result = @helper.update({email: email, memberUUId: token, isActive: 0}, "$set" => {isActive: Ash::Disposition::COMMON_ACTIVE.to_s, verifyTime: Time.now.to_i.to_s})
				result['updatedExisting']
			end

		end
	end
end
