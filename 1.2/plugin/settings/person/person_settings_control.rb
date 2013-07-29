#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'json'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/control.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
end

module Ash
	module ModuleApp

		class PersonSettingControl < Ash::ModuleApp::Control
			
		end
	end
end
