#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/BaseTeamsDB.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}BaseTeamsDB.rb"
end

module Ash
	module ExtraDB

		class CProjectTeamsHelper < Ash::ExtraDB::CBaseTeamsHelper

			public
			def find_all_part_project_ids(tid)
				project_ids = @helper.find_one({_id: BSON::ObjectId(tid)}, 'createdProjects')
				return [] if project_ids.nil?
				project_ids
			end

			def find_all_part_member_ids(tid)
				member = @helper.find_one({_id: BSON::ObjectId(tid)}, 'participatingMembers')
				return [] if member.nil?
				format_result(member)[:team_members]
			end
		end
	end
end
