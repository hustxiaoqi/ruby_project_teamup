#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/view.rb"
	require "#{MAIN_PATH}plugin/settings/person/person_settings_control.rb"
	require "#{MAIN_PATH}system/common/utils_common.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}view.rb"
	require "#{Ash::Disposition::MAIN_DIR_PLUGIN}settings#{File::SEPARATOR}person#{File::SEPARATOR}person_settings_control.rb"
end

require 'erb'

module Ash
	module ModuleApp
		
		class PersonSettingsView < Ash::ModuleApp::View
			
			def initialize
				super(Ash::ModuleApp::PersonSettingControl.new)
			end
			
			def default(uid, email, xhr)
				photo = Ash::ExtraDB::PersonSMHelper.new.find_member_profile(uid)
				return Ash::UtilsBase.integrate_unable_eresult if photo.nil?
				photo = Ash::UtilsCommon.format_member_profile_path(photo)
				if Object.const_defined? :ASH_DEBUG
					body = ERB.new(self.load_xhr_html('person_settings.rhtml', 'settings/person/')).result(binding())
				else
					body = ERB.new(self.load_xhr_html('person_settings.rhtml')).result(binding())
				end
				xhr ? body : self.load_head_html + body + self.load_bottom_html
			end

			def view_verify_psetting(*args)
				@api.ct_verify_psetting(*args)
			end

			def view_verify_ps_photo(*args)
				@api.ct_verify_ps_photo(*args)
			end
			#def view_verify_register(*args); @api.ct_verify_register(*args); end

			#def view_random_image(*args); @api.ct_random_image(*args); end

			#def view_onverify_register(*args); @api.ct_onverify_register(*args); end
		end
	end
end
