#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'json'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/control.rb"
	require "#{MAIN_PATH}include/class/member/person_settings_member.rb"
	require "#{MAIN_PATH}include/config/common_config.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}person_settings_member.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CONFIG}common_config.rb"
end

module Ash
	module ModuleApp

		class PersonSettingControl < Ash::ModuleApp::Control
			
			public
			def ct_verify_psetting(uid, name, briefs)
				name, briefs = name.strip, briefs.strip

				format_name = self.verify_member_name(name)
				return Ash::UtilsBase.integrate_result(false, 1, "Member Name Not Empty") if format_name == false
				format_briefs = self.verify_member_briefs(briefs)
				Ash::UtilsBase.integrate_unable_eresult unless self.update_members(uid, format_name, format_briefs)
				#begin
					#format_name = self.verify_member_name(name)
					#Ash::UtilsBase.integrate_result(false, 1, "Member Name Not Empty") if format_name == false
					#format_briefs = self.verify_member_briefs(briefs)
					#self.update_members(uid, format_name, format_briefs, format_profile)
				#rescue
					#Ash::UtilsBase.integrate_unable_eresult
				#end
				return Ash::UtilsBase.integrate_success_result
			end

			def update_members(*args)
				Ash::ExtraDB::PersonSMHelper.new.init_member(*args).update_member_brief
			end

			def verify_member_briefs(briefs)
				return Ash::Disposition::COMMON_MEMBER_BRIEFS_DEFAULT_INFO if briefs.empty?
				if Ash::UtilsBase.chars_zh?(briefs)
					briefs = briefs[0, Ash::Disposition::COMMON_MEMBER_BRIEFS_MAX_ZH_LENGTH]
				else
					briefs = briefs[0, Ash::Disposition::COMMON_MEMBER_BRIEFS_MAX_US_LENGTH]
				end
				briefs

			end

			def verify_member_name(name)
				return false if name.empty?
				if Ash::UtilsBase.chars_zh?(name)
					name = name[0, Ash::Disposition::COMMON_MEMBER_NAME_MAX_ZH_LENGTH]
				else
					name = name[0, Ash::Disposition::COMMON_MEMBER_NAME_MAX_US_LENGTH]
				end
				name
			end

			##=========>
			# update photo
			#
			def ct_verify_ps_photo(uid, picture)
				pp picture
			end

		end
	end
end
