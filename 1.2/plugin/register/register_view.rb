#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require "#{Ash::Disposition::SYS_DIR_BASE}BaseView.rb"
require "#{Ash::Disposition::MAIN_DIR_PLUGIN}register#{File::SEPARATOR}RegisterControl.rb"

module Ash
	module ModuleApp
		
		class RegisterView < View
			
			def initialize
				super(RegisterControl.new)
			end
			
			def default; load_static_file('register.html'); end

			def view_verify_register(*args); @api.ct_verify_register(*args); end

			def view_random_image(*args); @api.ct_random_image(*args); end

			def view_onverify_register(*args); @api.ct_onverify_register(*args); end
		end
	end
end
