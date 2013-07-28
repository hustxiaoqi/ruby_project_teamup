#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

#require 'json'
require 'digest'
require 'securerandom'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/base/BaseControl.rb"
	require "#{MAIN_PATH}include/class/ProjectTeamsDB.rb"
	require "#{MAIN_PATH}include/class/ProjectProjectsDB.rb"
	require "#{MAIN_PATH}include/class/ProjectMembersDB.rb"
else
	require "#{Ash::Disposition::SYS_DIR_BASE}BaseControl.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}ProjectTeamsDB.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}ProjectProjectsDB.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}ProjectMembersDB.rb"
end


module Ash
	module ModuleApp

		class CControlProject < Ash::ModuleApp::CControl
			
			public
			def ct_default(uid, tid, tuuid, tauth)
				return false unless Ash::ExtraDB::CProjectTeamsHelper.new.team?(tid, tuuid)
				
				governor = (tauth == Ash::Disposition::COMMON_TEAM_CREATE_AUTHORITY or tauth == Ash::Disposition::COMMON_TEAM_MANAGE_AUTHORITY)
				part_pid_arr = Ash::ExtraDB::CProjectTeamsHelper.new.find_all_part_project_ids(tid)
				return part_pid_arr if part_pid_arr.empty?
				#Ash::ExtraDB::CProjectProjectsHelper.new.find_all_part_projects(part_pid_arr)
				[governor, []]
			end

			def ct_ajax_newproject(uid, tid, tuuid, tauth)
				project_helper = Ash::ExtraDB::CProjectTeamsHelper.new
				return false unless project_helper.team?(tid, tuuid)
				return false unless (tauth == Ash::Disposition::COMMON_TEAM_CREATE_AUTHORITY or tauth == Ash::Disposition::COMMON_TEAM_MANAGE_AUTHORITY)
				Ash::ExtraDB::CProjectMembersHelper.new.find_all_user_infos(project_helper.find_all_part_member_ids(tid))
			end

			def ct_verify_newproject(uid, tid, tuuid, tauth, name, content)
				project_helper = Ash::ExtraDB::CProjectTeamsHelper.new
				return false unless project_helper.team?(tid, tuuid)
				return false unless (tauth == Ash::Disposition::COMMON_TEAM_CREATE_AUTHORITY or tauth == Ash::Disposition::COMMON_TEAM_MANAGE_AUTHORITY)

			end

		end
		
	end
end
