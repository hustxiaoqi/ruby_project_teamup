#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require "#{Ash::Disposition::SYS_DIR_CORE}view.rb"
require "#{Ash::Disposition::MAIN_DIR_PLUGIN}team#{File::SEPARATOR}team_control.rb"

module Ash
	module ModuleApp
		
		class TeamView < Ash::ModuleApp::View
			
			def initialize
				super(Ash::ModuleApp::TeamControl.new)
			end
			
			def default; "hello"; end

			def view_ready_teams(*args); @api.ct_ready_teams(*args); end

		end
	end
end
