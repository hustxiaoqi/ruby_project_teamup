#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'pp'
require 'json'
require 'digest'
require 'securerandom'
require "#{Ash::Disposition::SYS_DIR_BASE}BaseControl.rb"
#require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}BaseMemberDB.rb"
#require "#{Ash::Disposition::SYS_DIR_BASE}BaseSendEmail.rb"

#
# return
#   Type = 0 ==> Success
#   Type = 1 ==> Input Error
#   Type = 2 ==> Send Email Error
#   Type = 8 ==> Unable Error

module Ash
	module ModuleApp

		class CControlHome < Ash::ModuleApp::CControl
			
		end
	end
end
