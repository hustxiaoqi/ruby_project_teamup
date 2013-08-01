#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR


if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/control.rb"
	require "#{MAIN_PATH}include/class/member/person_settings_member.rb"
	require "#{MAIN_PATH}include/config/common_config.rb"
	require "#{MAIN_PATH}system/common/utils_common.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}person_settings_member.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CONFIG}common_config.rb"
end

require 'json'
require 'fileutils'

module Ash
	module ModuleApp

		class PersonSettingsControl < Ash::ModuleApp::Control

			include Ash::UtilsBase
			
			public
			def ct_verify_psetting(uid, name, briefs)
				name, briefs = name.strip, briefs.strip

				begin
					format_name = self.verify_member_name(name)
					return UtilsBase.integrate_result(false, 1, "Member Name Not Empty") if format_name == false
					format_briefs = self.verify_member_briefs(briefs)
					return UtilsBase.integrate_unable_result unless self.update_members(uid, format_name, format_briefs)
				rescue
					raise if UtilsCommon.dev_mode?
					UtilsBase.integrate_unable_eresult
				end
				UtilsBase.integrate_success_result
			end

			def update_members(*args)
				ExtraDB::PersonSMHelper.new.init_member(*args).update_member_brief
			end

			def verify_member_briefs(briefs)
				return Disposition::COMMON_MEMBER_BRIEFS_DEFAULT_INFO if briefs.empty?
				UtilsBase.chars_zh?(briefs) ? briefs[0, Disposition::COMMON_MEMBER_BRIEFS_MAX_ZH_LENGTH] : briefs[0, Disposition::COMMON_MEMBER_BRIEFS_MAX_US_LENGTH]

			end

			def verify_member_name(name)
				return false if name.empty?
				UtilsBase.chars_zh?(name) ? name[0, Disposition::COMMON_MEMBER_NAME_MAX_ZH_LENGTH] : name[0, Disposition::COMMON_MEMBER_NAME_MAX_US_LENGTH]
			end

			##=========>
			# update photo
			#
			def ct_verify_ps_photo(uid, picture = nil)
				begin
					return UtilsBase.integrate_err_result(1, "Picture Empty") if picture.nil?
					return UtilsBase.integrate_err_result(2, "Picture Type Error") unless UtilsCommon.profile?(picture[:tempfile].path)
					image_name = UtilsCommon.format_image_name(uid)
					if Object.const_defined? :ASH_DEBUG
						UtilsCommon.format_image(picture[:tempfile].path, "#{MAIN_PATH}assets/image/user_gallery/#{image_name}")
					else
						UtilsCommon.format_image(picture[:tempfile].path, "#{MAIN_DIR_ASSETS_IMAGE}user_gallery#{File::SEPARATOR}#{image_name}")
					end
					UtilsBase.integrate_unable_eresult unless ExtraDB::PersonSMHelper.new.update_member_profile(uid, image_name)
					UtilsBase.integrate_success_result
				rescue
					raise if UtilsCommon.dev_mode?
					UtilsBase.integrate_unable_result
				end
			end

			###########=====>
			# alter password

			def ct_verify_altpwd(uid, old_pwd = "", new_pwd = "")
				old_pwd, new_pwd = old_pwd.strip, new_pwd.strip

				begin
					return UtilsBase.integrate_err_result(1, "Passowrd Not Empty")  if new_pwd.empty? or old_pwd.empty?
					return UtilsBase.integrate_err_result(2, "Passowrd Error") if !UtilsBase.arr_password?(old_pwd, new_pwd) || !ExtraDB::PersonSMHelper.new.password?(uid, old_pwd)
					return UtilsBase.integrate_equal_result("Passowrd Equal") if old_pwd == new_pwd
					return UtilsBase.integrate_unable_result unless ExtraDB::PersonSMHelper.new.update_member_pwd(uid, new_pwd)
					UtilsBase.integrate_success_result
				rescue
					raise if UtilsCommon.dev_mode?
					UtilsBase.integrate_success_result
				end
			end
		end
	end
end
