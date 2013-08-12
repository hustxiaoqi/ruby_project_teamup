#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/view.rb"
	require "#{MAIN_PATH}login/login_control.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}view.rb"
	require "#{Ash::Disposition::MAIN_DIR_PLUGIN}login#{ASH_SEP}login_control.rb"
end

module Ash
	module ModuleApp

		class LoginView < View

			def initialize
				super(Ash::ModuleApp::LoginControl.new)
			end

			def default; self.load_static_file('login.html'); end

			def view_verify_login(*args); @api.ct_verify_login(*args); end

			def view_random_image(*args); @api.ct_random_image(*args); end

			def view_forgot_pwd; self.load_static_file('forgot_password.html', 'login'); end

			def view_verify_forgot_pwd(*args); @api.ct_verify_forgot_pwd(*args); end

			def view_reset_pwd(*args); self.load_static_file('reset_password.html', 'login'); end

			def view_verify_reset_pwd(*args); @api.ct_verify_reset_pwd(*args); end
		end
	end
end
