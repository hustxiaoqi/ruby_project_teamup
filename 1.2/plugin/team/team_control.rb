#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

#require 'json'
require 'digest'
require 'securerandom'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/control.rb"
	require "#{MAIN_PATH}include/class/TeamMembersDB.rb"
	require "#{MAIN_PATH}include/class/TeamTeamsDB.rb"
else
	require "#{Ash::Disposition::SYS_DIR_BASE}BaseControl.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}TeamMembersDB.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}TeamTeamsDB.rb"
end

#
# return
#   Type = 0 ==> Success
#   Type = 1 ==> Input Error
#   Type = 2 ==> Send Email Error
#   Type = 8 ==> Unable Error

module Ash
	module ModuleApp

		class CControlTeam < Ash::ModuleApp::CControl
			
			public
			def ct_ready_teams(session)
				team = Ash::ExtraDB::CTeamMembersHelper.new.find_using_teams(session['ash_uid'])
				session[:ash_ttid], session[:ash_tauth] = team[:team_id], team[:authority]
				session[:ash_tuuid] = Ash::ExtraDB::CTeamTeamsHelper.new.find_uuid_by_ttid(team[:team_id])
			end
		end
		
	end
end
