#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'pp'
require 'json'
require 'digest'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/control.rb"
	require "#{MAIN_PATH}include/class/member/login_member.rb"
	require "#{MAIN_PATH}system/base/random_image.rb"
	require "#{MAIN_PATH}include/class/login_random_image.rb"
	require "#{MAIN_PATH}include/config/dir_config.rb"
	require "#{MAIN_PATH}system/common/utils_common.rb"
	require "#{MAIN_PATH}system/common/utils_base.rb"
	require "#{MAIN_PATH}system/base/send_bae_email.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}login_member.rb"
	require "#{Ash::Disposition::SYS_DIR_BASE}random_image.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}login_random_image.rb"
	require "#{Ash::Disposition::SYS_DIR_BASE}send_bae_email.rb"
end

module Ash
	module ModuleApp

		class LoginControl < Control
			
			def ct_verify_login(email, pwd, token, session)
				begin
					email, pwd, token = email.strip, pwd.strip, token.strip

					!UtilsBase.email?(email) and return UtilsBase.inte_err_info(1002, "User Email Input Error")
					!UtilsBase.password?(pwd) and return UtilsBase.inte_err_info(1003, "User Password Input Error")
					r_random = ExtraDB::LoginRImgHelper.new(email)
					(token_info = self.check_token(r_random, token)) === true or return token_info
					(user_info = self.check_set_user(email, pwd, session)) === true or return user_info
					UtilsBase.inte_succ_info
				rescue
					ASH_MODE == ASH_MODE_DEV and raise
					UtilsBase.inte_bigerr_info
				end
			end

			protected
			def check_token(obj, token)
				token.length != 4 and return UtilsBase.inte_err_info(1004, "Verification Code Input Error")
				result = obj.find_by_email
				result.nil? and return UtilsBase.inte_bigerr_info

				begin
					time_diff = (Time.now.to_i - result.time.to_i)
					return UtilsBase.inte_err_info(1005, "Time Over") if time_diff <= 0 or time_diff > Disposition::COMMON_TOKEN_EXPIRES
					result.token.downcase == token.downcase or return UtilsBase.inte_err_info(1006, 'Verification Code Input Error')
				rescue
					ASH_MODE == ASH_MODE_DEV and raise
					return UtilsBase.inte_bigerr_info
				ensure
					obj.remove_by_email
					UtilsCommon.delete_random_image(result.path)
				end
				true
			end

			def check_set_user(email, pwd, session)
				lm = ExtraDB::LoginMHelper.new.init_member(email: email, password: pwd).verify_member
				lm.nil? and return UtilsBase.inte_err_info(1007, 'Account Error')
				session[:ash_uid], session[:ash_uname], session[:ash_uemail], session[:ash_uact], session[:ash_ustartt] = lm.id, lm.name, lm.email, lm.active, Time.now.to_i.to_s
				true
			end


			#===> random
			public
			def ct_random_image(email)
				begin
					return UtilsBase.inte_err_info(1001, "User Email Input Error") unless UtilsBase.email? email
					time = Time.now.to_i.to_s
					result = (r_helper = ExtraDB::LoginRImgHelper.new(email)).find_by_email
					if result != nil
						UtilsCommon.delete_random_image(result.path)
						r_helper.remove_by_email
					end
					r_image = Utils::RandomImage.new.picture(time, "#{Disposition::MAIN_DIR_ASSETS_IMAGE}verify#{File::SEPARATOR}")
					r_helper.insert(time, r_image.image_text, r_image.image_name)
					UtilsBase.inte_basic_info(status: true, lenght: 4, type: Disposition::COMMON_PAGE_SUCCESS, info: "/image/verify/#{r_image.image_name}")
				rescue
					ASH_MODE == ASH_MODE_DEV and raise
					UtilsBase.inte_bigerr_info
				end
			end

			#===> forgot password
			public
			def ct_verify_forgot_pwd(email)
				begin
					!UtilsBase.email?(email) and return UtilsBase.inte_err_info(1010, "Email Format Error")
					lm_helper = ExtraDB::LoginMHelper.new.init_member(email: email)
					mh = lm_helper.verify_email
					mh.nil? and return UtilsBase.inte_err_info(1011, "Email Not Exist")
					mh.active == false and return UtilsBase.inte_err_info(1012, "Account Not Active")
					mh.frozen == true and return UtilsBase.inte_err_info(1013, "Account Has Frozen And 2 Days After Register Again")
					s_info = self.send_onverify_email(mh.uuid, email)
					return s_info unless s_info === true
					lm_helper.update_reset_time
					UtilsBase.inte_succ_info
				rescue
					ASH_MODE == ASH_MODE_DEV and raise
					UtilsBase.inte_bigerr_info
				end
			end

			def send_onverify_email(uuid, email)
				bae_send = Utils::SendBaeEmail.new(address: [email], subject: 'Reset Your Password')
				href = "#{Disposition::COMMON_BASE_URI}login/reset_password/#{uuid}?l_r_u_type=email"
				bae_send.message = '<h2>Hi ' + email + '</h2><div><p>Click Reset Your Password</p><p><a style="font-size:14px;font-weight:bold;color:white;border:1px solid #0d851b;background:#15981e;text-decoration:none;padding:5px 10px" href="' + href + '">Reset your Password</a></p></div><div><p>Sincerely,</p></p>The Teamup Team</p></div>'

				bae_send.send or UtilsBase.inte_err_info(1014, 'Email Send Error')
			end

			#===> reset password
			public
			def ct_verify_reset_pwd(uuid, pwd)
				begin
					uuid, pwd = uuid.strip, pwd.strip
					!UtilsBase.uuid?(uuid) and return UtilsBase.inte_err_info(1020, "Params Error")
					!UtilsBase.password?(pwd) and return UtilsBase.inte_err_info(1021, "Password Format Error")
					lm_helper = ExtraDB::LoginMHelper.new.init_member(uuid: uuid, password: Digest::MD5.hexdigest(pwd))
					m_info = lm_helper.verify_reset_time
					m_info.overtime == true and return UtilsBase.inte_err_info(1022, "Reset Time Over Time")
					m_info.password == true and return UtilsBase.inte_equal_info('Password Same')
					!lm_helper.update_pwd and return UtilsBase.inte_err_info(1023, "Reset Password Error")
					UtilsBase.inte_succ_info
				rescue
					ASH_MODE == ASH_MODE_DEV and raise
					UtilsBase.inte_bigerr_info
				end
			end

		end
	end
end
