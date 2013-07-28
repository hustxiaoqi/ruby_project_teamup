#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require "#{Ash::Disposition::SYS_DIR_LIB}LibView#{FILE_EXT}"
require "#{Ash::Disposition::MAIN_DIR_PLUGIN}home#{File::SEPARATOR}HomeControl#{FILE_EXT}"

module Ash
	module ModuleApp
		
		class CViewHome < Ash::ModuleApp::CView
			
			def initialize
				super(Ash::ModuleApp::CControlHome.new)
			end
			
			def default; load_static_file('home.html'); end

			#def view_verify_register(*args); @api.ct_verify_register(*args); end

			#def view_random_image(*args); @api.ct_random_image(*args); end

			#def view_onverify_register(*args); @api.ct_onverify_register(*args); end
		end
	end
end
