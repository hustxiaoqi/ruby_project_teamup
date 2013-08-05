#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR
require 'pp'
require 'json'
require 'digest'
require 'securerandom'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/common/utils_base.rb"
else
	require "#{Ash::Disposition::SYS_DIR_COMMON}utils_base.rb"
end

require "#{Ash::Disposition::SYS_DIR_BASE}BaseControl.rb"
require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}RegisterMemberDB.rb"
require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}RegisterTeamsDB.rb"
require "#{Ash::Disposition::SYS_DIR_BASE}BaseSendEmail.rb"

module Ash
	module ModuleApp

		class RegisterControl < Control
			
			public
			def ct_verify_register(party_name, email, pwd)
				begin
					party_name, email, pwd = party_name.strip, email.strip, pwd.strip

					party_name.empty? and return UtilsBase.inte_err_info(2001, "Party Name Not Empty")
					!UtilsBase.email?(email) and return UtilsBase.inte_err_info(2002, "Email Input Error")
					!UtilsBase.password?(pwd) and return UtilsBase.inte_err_info(2003, "Password Input Error")
					rm_helper = RegisterMHeper.new.init_member(email, pwd)
					rm_helper.exist_email? and return UtilsBase.inte_err_info(2004, "Email Have Been Used")
					(m_result = self.insert_party(rm_helper, party_name)) === true or return m_result
					self.send_onverify_email(m_result, party_name, email)
					UtilsBase.inte_succ_info
				rescue
					ASH_MODE == ASH_MODE_DEV and raise
					UtilsBase.inte_bigerr_info
				end
			end

			protected
			def insert_party(rm_helper, party_name)
				m_info = rm_helper.insert_briefs
				m_info.nil? and return UtilsBase.inte_bigerr_info

				t_id = RegisterTHeper.new.init_team(m_info.id, party_name).insert_briefs
				t_id.empty? and return UtilsBase.inte_bigerr_info
				!rm_helper.update_teams(m_info.id, t_id) and return UtilsBase.inte_bigerr_info
				m_info
			end

			def send_onverify_email(m_info, party_name, email)

				send_info = {party_name: party_name, user_href: "http://127.0.0.1:8080/register/onverify?r_u_email=#{email}&r_u_token=#{m_info.uuid}&r_u_type=email"}
				return {status: false, info: "Email Send Error", type: 2}.to_json unless Ash::Utils::CSendEmail.new(email).send_verify_html(send_info)
				true
			end


			#==> email verify register
			#Error
			# Type 1 ==> Email Format Error
			# Type 2 ==> Token Format Error
			# Type 3 ==> Verify Type Error
			# Type 5 ==> Email Do Not Exist
			# Type 6 ==> Email Verify Over Time
			# Type 7 ==> Email Send Error
			# Type 8 ==> Unable Error
			# Type 0 ==> Success
			public
			def ct_onverify_register(email, token, type)
				email, token, type = email.strip, token.strip, type.strip

				return self.integrate_result(false, 1, "Email Format Error") unless self.c_email? email
				return self.integrate_result(false, 2, "Token Format Error") unless self.c_onverify_token? token
				return self.integrate_result(false, 3, "Verify Type Error") unless type == 'email'
				i_onverify_value = self.c_onverify_email(email, token)
				return i_onverify_value unless i_onverify_value === true
				self.onverify_party_info(email, token)
				#begin
					#return self.integrate_result(false, 1, "Email Format Error") unless self.c_email? email
					#return self.integrate_result(false, 2, "Token Format Error") unless self.c_onverify_token? token
					#return self.integrate_result(false, 3, "Verify Type Error") unless type == 'email'
					#i_onverify_value = self.c_onverify_email(email, token)
					#return i_onverify_value unless i_onverify_value === true
					#self.onverify_party_info(email, token)
				#rescue
					#return self.integrate_result(false, 8, "Unable Error")
				#end
				self.integrate_result true, 0, "Success"
			end

			protected
			def c_onverify_token?(token); token.length == Digest::SHA1.hexdigest(SecureRandom.uuid).length; end

			def c_onverify_email(email, token)
				result = Ash::ExtraDB::CRegisterMembersHelper.new.find_onverify_email(email, token)
				return true if result[:status] === true
				return {status: false, info: "Email Do Not Exist", type: 5} if result[:type] == 1
				return {status: false, info: "Email Verify Over Time", type: 6} if result[:type] == 2
			end

			def onverify_party_info(email, token)
				Ash::ExtraDB::CRegisterMembersHelper.new.update_onverify_info(email, token)
				return {status: false, info: "Email Send Error", type: 7}.to_json unless Ash::Utils::CSendEmail.new(email).send_onverify_success_html
			end
		end
	end
end
