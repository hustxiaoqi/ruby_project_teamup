#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'pp'
require 'json'
require 'digest'
require 'securerandom'
require "#{Ash::Disposition::SYS_DIR_LIB}LibControl#{FILE_EXT}"
require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}ClassMemberDB#{FILE_EXT}"
require "#{Ash::Disposition::SYS_DIR_BASE}BaseSendEmail#{FILE_EXT}"

#
# return
#   Type = 0 ==> Success
#   Type = 1 ==> Input Error
#   Type = 2 ==> Send Email Error
#   Type = 8 ==> Unable Error

module Ash
	module ModuleApp

		class CControlHome < Ash::ModuleApp::CControl
			
			public
			def ct_verify_register(party_name, email, pwd, session)
				party_name, email, pwd = party_name.strip, email.strip, pwd.strip

				return self.integrate_result(false, "Party Name Do Not Empty") unless self.c_party_name? party_name
				return self.integrate_result(false, "Email Input Error") unless self.c_email? email
				return self.integrate_result(false, "Password Input Error") unless self.c_password? pwd
				return self.integrate_result(false, "Email Have Been Used") if self.c_exist_email? email
				i_value = self.insert_party_info_and_send(party_name, email, pwd, session)
				return i_value unless i_value === true
				#begin
					#return self.integrate_result(false, "Party Name Do Not Empty") unless self.c_party_name? party_name
					#return self.integrate_result(false, "Email Input Error") unless self.c_email? email
					#return self.integrate_result(false, "Password Input Error") unless self.c_password? pwd
					#return self.integrate_result(false, "Email Have Been Used") if self.c_exist_email? email
					#i_value = self.insert_party_info_and_send(party_name, email, pwd, session)
					#return i_value unless i_value === true
				#rescue
					#return self.integrate_result(false, 8, "Unable Error")
				#end
				self.integrate_result true, 0, "success"
			end

			protected
			def integrate_result(status = true, type = 1, info); {status: status, info: info, type: type}.to_json; end
			
			def c_party_name?(party_name); party_name.length  != 0; end

			def c_email?(email); (/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/ =~ email) == 0; end

			def c_password?(pwd); pwd.to_s.length == Digest::MD5.hexdigest('').length; end

			def c_exist_email?(email); Ash::ExtraDB::CMemberHelper.new.email?(email); end;

			def insert_party_info_and_send(party_name, email, pwd, session)
				token = SecureRandom.uuid
				send_info = {party_name: party_name, user_href: "http://127.0.0.1:4567/register/onverify?r_u_email=#{email}&r_u_token=#{token}&r_u_type=email"}

				return {status: false, info: "Email Send Error", type: 2}.to_json unless Ash::Utils::CSendEmail.new(email).send_verify_html(send_info)
				#return {status: false, info: "Email Send Error", type: 2}.to_json unless Ash::Utils::CSendEmail.new(email).send(send_info)
				insert_id = Ash::ExtraDB::CMemberHelper.new.insert_member(party_name, email, pwd, token, Time.now.to_i.to_s)
				session[:ash_act_id], session[:ash_user_email], session[:ash_party_name] = insert_id, email, party_name
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
					#self.onverify_party_info(email, pwd)
				#rescue
					#return self.integrate_result(false, 8, "Unable Error")
				#end
				self.integrate_result true, 0, "Success"
			end

			protected
			def c_onverify_token?(token); (token =~ /^[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}$/) == 0; end

			def c_onverify_email(email, token)
				result = Ash::ExtraDB::CMemberHelper.new.find_onverify_email(email, token)
				return true if result[:status] === true
				return {status: false, info: "Email Do Not Exist", type: 5} if result[:type] == 1
				return {status: false, info: "Email Verify Over Time", type: 6} if result[:type] == 2
			end

			def onverify_party_info(email, token)
				Ash::ExtraDB::CMemberHelper.new.update_onverify_info(email, token)
				return {status: false, info: "Email Send Error", type: 7}.to_json unless Ash::Utils::CSendEmail.new(email).send_onverify_success_html
			end
		end
	end
end
