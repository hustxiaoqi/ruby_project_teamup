#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/control.rb"
	require "#{MAIN_PATH}include/class/member/register_member.rb"
	require "#{MAIN_PATH}include/class/team/register_team.rb"
	require "#{MAIN_PATH}system/common/utils_base.rb"
	require "#{MAIN_PATH}include/config/common_config.rb"
	require "#{MAIN_PATH}system/base/send_bae_email.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}register_member.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}team#{File::SEPARATOR}register_team.rb"
	require "#{Ash::Disposition::SYS_DIR_BASE}send_bae_email.rb"
end

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
					rm_helper = ExtraDB::RegisterMHelper.new.init_member(email: email, password: pwd)
					rm_helper.exist_email? and return UtilsBase.inte_err_info(2004, "Email Have Been Used")
					(m_result = self.insert_party(rm_helper, party_name)).is_a?(Struct) or return m_result
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

				t_id = ExtraDB::RegisterTHelper.new.init_team(m_info.id, party_name).insert_briefs
				t_id.empty? and return UtilsBase.inte_bigerr_info
				!rm_helper.update_teams(m_info.id, t_id) and return UtilsBase.inte_bigerr_info
				m_info
			end

			def send_onverify_email(m_info, party_name, email)
				bae_send = Utils::SendBaeEmail.new(address: [email], subject: 'Complete your TeamUp registration with one click!')
				href = "#{Disposition::COMMON_BASE_URI}register/onverify?r_u_email=#{email}&r_u_token=#{m_info.uuid}&r_u_type=email"
				bae_send.message = '<h2>Hi ' + party_name + '</h2><div><p>Thanks for signing up, we just need to verify your email address:</p><p><a style="font-size:14px;font-weight:bold;color:white;border:1px solid #0d851b;background:#15981e;text-decoration:none;padding:5px 10px" href="' + href + '">Verify your email address</a></p></div><div><p>Sincerely,</p></p>The Teamup Team</p></div>'

				bae_send.send or UtilsBase.inte_err_info(2005, 'Email Send Error')
			end


			#==> email verify register
			public
			def ct_onverify_register(email, token, type)
				begin
					email, token, type = email.strip, token.strip, type.strip

					!UtilsBase.email?(email) and return UtilsBase.inte_err_info(2002, "Email Format Error")
					!UtilsBase.uuid?(token) and return UtilsBase.inte_err_info(2006, "Token Format Error")
					type != 'email' and return UtilsBase.inte_err_info(2007, "Verify Type Error")

					rm_helper = ExtraDB::RegisterMHelper.new.init_member(email: email, uuid: token)
					!(verify_email = self.onverify_email(rm_helper)).nil? and return verify_email
					rm_helper.update
					UtilsBase.inte_succ_info
				rescue
					ASH_MODE == ASH_MODE_DEV and raise
					UtilsBase.inte_bigerr_info
				end
			end

			protected
			def onverify_email(rm_helper)
				verify = rm_helper.find_onverify
				verify.nil? and return UtilsBase.inte_err_info(2008, 'Member Not Exist')
				verify.active and return UtilsBase.inte_err_info(2009, 'Member Has Been Active')

				time = Time.now.to_i - verify.registered_time.to_i
				if time < 0 or time > Disposition::COMMON_EMAIL_TOKEN_EXPIRES
					rm_helper.delete
					return UtilsBase.inte_err_info(2010, 'Email Verify Over Time')
				end
				return
			end

		end
	end
end
