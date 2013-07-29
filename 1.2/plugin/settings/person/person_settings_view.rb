#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/view.rb"
	require "#{MAIN_PATH}plugin/settings/person/person_settings_control.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}view.rb"
	require "#{Ash::Disposition::MAIN_DIR_PLUGIN}settings#{File::SEPARATOR}person#{File::SEPARATOR}person_settings_control.rb"
end

module Ash
	module ModuleApp
		
		class PersonSettingsView < Ash::ModuleApp::View
			
			def initialize
				super(Ash::ModuleApp::PersonSettingControl.new)
			end
			
			def default(xhr)
				if xhr
					self.integrate_xhr_file('person_settings.html')
				else
					self.integrate_static_file('person_settings.html')
				end
			end

			#def view_verify_register(*args); @api.ct_verify_register(*args); end

			#def view_random_image(*args); @api.ct_random_image(*args); end

			#def view_onverify_register(*args); @api.ct_onverify_register(*args); end
		end
	end
end
