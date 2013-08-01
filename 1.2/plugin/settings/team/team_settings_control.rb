#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR


if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/control.rb"
	require "#{MAIN_PATH}include/config/common_config.rb"
	require "#{MAIN_PATH}system/common/utils_common.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CONFIG}common_config.rb"
end

require 'json'
require 'fileutils'

module Ash
	module ModuleApp

		class TeamSettingsControl < Ash::ModuleApp::Control


		end
	end
end
