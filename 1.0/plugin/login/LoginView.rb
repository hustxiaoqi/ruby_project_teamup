#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require "#{Ash::Disposition::SYS_DIR_LIB}LibView#{FILE_EXT}"
require "#{Ash::Disposition::MAIN_DIR_PLUGIN}login#{File::SEPARATOR}LoginControl#{FILE_EXT}"

module Ash
	module ModuleApp
		
		class CViewLogin < Ash::ModuleApp::CView
			
			def initialize
				super(Ash::ModuleApp::CControlLogin.new)
			end
			
			def default; load_static_file('login.html'); end

			def view_verify_login(*args); @api.ct_verify_login(*args); end

			def view_random_image(*args); @api.ct_random_image(*args); end
		end
	end
end
