#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'json'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/control.rb"
	require "#{MAIN_PATH}include/class/member/team_member.rb"
	require "#{MAIN_PATH}include/class/team/team_team.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}team_member.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}team#{File::SEPARATOR}team_team.rb"
end

module Ash
	module ModuleApp

		class TeamControl < Ash::ModuleApp::Control
			
			public
			def ct_ready_teams(session)
				if Object.const_defined? :ASH_DEBUG
					team = Ash::ExtraDB::TeamMHelper.new.init_member(session['ash_uid']).find_using_teams
				else
					team = Ash::ExtraDB::TeamMHelper.new.init_member(session[:ash_uid]).find_using_teams
				end
				return {status: false, info: 'Unable Error', type: 1}.to_json if team.nil?
				session[:ash_ttid], session[:ash_tauth] = team.id, team.authority
				team_uuid = Ash::ExtraDB::TeamTHelper.new.init_team(team.id).find_uuid_by_ttid
				return {status: false, info: 'Unable Error', type: 1}.to_json if team_uuid.nil?
				session[:ash_tuuid] = team_uuid
				true
			end
		end
		
	end
end
