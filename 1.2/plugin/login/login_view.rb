#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require "#{Ash::Disposition::SYS_DIR_CORE}view.rb"
require "#{Ash::Disposition::MAIN_DIR_PLUGIN}login#{File::SEPARATOR}login_control.rb"

module Ash
	module ModuleApp
		
		class LoginView < Ash::ModuleApp::View
			
			def initialize
				super(Ash::ModuleApp::LoginControl.new)
			end
			
			def default; load_static_file('login.html'); end

			def view_verify_login(*args); @api.ct_verify_login(*args); end

			def view_random_image(*args); @api.ct_random_image(*args); end
		end
	end
end
