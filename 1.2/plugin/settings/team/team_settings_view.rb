#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/view.rb"
	require "#{MAIN_PATH}plugin/settings/team/team_settings_control.rb"
	require "#{MAIN_PATH}system/common/utils_common.rb"
	require "#{MAIN_PATH}system/common/utils_base.rb"
	require "#{MAIN_PATH}include/class/team/team_settings_team.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}view.rb"
	require "#{Ash::Disposition::MAIN_DIR_PLUGIN}settings#{File::SEPARATOR}team#{File::SEPARATOR}team_settings_control.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}team#{File::SEPARATOR}team_settings_team.rb"
end

require 'erb'

module Ash
	module ModuleApp
		
		TeamSVResult = Struct.new(:team_name, :team_created_time, :team_intro) do
			def get_binding; binding(); end
		end

		class TeamSettingsView < ModuleApp::View
			
			def initialize
				super(ModuleApp::TeamSettingsControl.new)
			end
			
			def default(tid, auth, xhr)
				return UtilsBase.integrate_err_result(1, "Not Access") unless ExtraDB::TeamHelper.governor?(auth)
				result = ExtraDB::TeamSTHelper.new.init_team(tid).find_team_briefs
				return UtilsBase.integrate_unable_result if result.nil?
				viewer = TeamSVResult.new(result.name, UtilsBase.format_time(result.created_time), result.introduction)
				if Object.const_defined? :ASH_DEBUG
					body = ERB.new(self.load_xhr_html('team_settings.rhtml', 'settings/team/')).result(viewer.get_binding)
				else
					body = ERB.new(self.load_xhr_html('team_settings.rhtml')).result(viewer.get_binding)
				end
				xhr ? body : self.load_head_html + body + self.load_bottom_html
			end

		end
	end
end
