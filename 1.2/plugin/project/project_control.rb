#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

#require 'json'
require 'digest'
require 'securerandom'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/control.rb"
	require "#{MAIN_PATH}include/class/team/project_team.rb"
	#require "#{MAIN_PATH}include/class/ProjectProjectsDB.rb"
	#require "#{MAIN_PATH}include/class/ProjectMembersDB.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}team#{File::SEPARATOR}project_team.rb"
	#require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}ProjectProjectsDB.rb"
	#require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}ProjectMembersDB.rb"
end


module Ash
	module ModuleApp

		class ProjectControl < Ash::ModuleApp::Control
			
			public
			def ct_default(uid, tid, tuuid, tauth)
				pt_helper = Ash::ExtraDB::ProjectTHelper.new
				pt_helper.init_team(tid, tuuid)
				return false unless pt_helper.team_helper.team?
				
				governor = pt_helper.governor?
				if governor
					projects = pt_helper.find_all_part
				end
				#part_pid_arr = Ash::ExtraDB::CProjectTeamsHelper.new.find_all_part_project_ids(tid)
				#return part_pid_arr if part_pid_arr.empty?
				##Ash::ExtraDB::CProjectProjectsHelper.new.find_all_part_projects(part_pid_arr)
				#[governor, []]
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
