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
else
	require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}login_member.rb"
	require "#{Ash::Disposition::SYS_DIR_BASE}random_image.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}login_random_image.rb"
end

module Ash
	module ModuleApp

		class LoginControl < Ash::ModuleApp::Control
			
			public
			def ct_verify_login(user_email, user_pwd, user_token, session)
				user_email, user_pwd, user_token, user_time = user_email.strip, user_pwd.strip, user_token, user_time

				return self.integrate_result(false, "User Email Input Error") unless Ash::UtilsBase.email? user_email
				return self.integrate_result(false, "User Password Input Error") unless self.user_password? user_pwd
				check_user_token_info = self.check_user_token(user_email, user_token)
				return self.integrate_result(false, check_user_token_info) unless check_user_token_info == true
				return self.integrate_result(false, "User Email or User Password Input Error") unless self.check_set_user(user_email, user_pwd, session) === true
				#begin
					#return self.integrate_result(false, "User Email Input Error") unless self.user_email? user_email
					#return self.integrate_result(false, "User Password Input Error") unless self.user_password? user_pwd
					#check_user_token_info = self.check_user_token(user_email, user_token)
					#return self.integrate_result(false, check_user_token_info) unless check_user_token_info == true
					#return self.integrate_result(false, "User Email or User Password Input Error") unless self.check_set_user(user_email, user_pwd, session) === true
				#rescue
					#return self.integrate_result false, "Unable False"
				#end
				self.integrate_result true, "success"
			end

			protected
			def integrate_result(status = true, info); {status: status, info: info}.to_json; end
			
			def user_password?(password); password.to_s.length == Digest::MD5.hexdigest('').length; end

			def check_user_token(email, token)
				return "Verification Code Input Error" if token.length != 4
				random_helper = Ash::ExtraDB::LoginRImgHelper.new
				result = random_helper.find_by_email(email)
				return "Unable Error" if result == nil

				begin
					time_diff = (Time.now.to_i - result['start_time'].to_i)
					return "Login Time Over Long" unless time_diff > 0 and time_diff <= Ash::Disposition::COMMON_TOKEN_EXPIRES
					return "Verification Code Input Error" unless result['old_token'].downcase == token.downcase
				rescue
					puts $!
					return "Unable False"
				ensure
					random_helper.remove_by_email(email)
					File.delete("#{Ash::Disposition::MAIN_DIR_ASSETS_IMAGE}verify#{File::SEPARATOR}#{result['image_path']}")
				end
				return true
			end

			def check_set_user(email, pwd, session)
				lm_helper = Ash::ExtraDB::LoginMHelper.new
				lm = lm_helper.init_member(email).find_member_info
				return false if lm == nil or Digest::MD5.hexdigest(pwd) != lm.password
				session[:ash_uid], session[:ash_uname], session[:ash_uemail], session[:ash_uact], session[:ash_ustartt] = lm.id, lm.name, lm.email, lm.active, Time.now.to_i.to_s
				true
			end


			#===> random
			public
			def ct_random_image(user_email, user_time)
				return self.integrate_result(false, "User Email Input Error") unless Ash::UtilsBase.email? user_email
				return self.integrate_result(false, "Time Error") unless self.user_time? user_time
				random_image = Ash::Utils::RandomImage.new
				random_image.picture(user_time, "#{Ash::Disposition::MAIN_DIR_ASSETS_IMAGE}verify#{File::SEPARATOR}")
				random_helper = Ash::ExtraDB::LoginRImgHelper.new
				result = random_helper.find_by_email(user_email)
				if result != nil
					File.delete("#{Ash::Disposition::MAIN_DIR_ASSETS_IMAGE}verify#{File::SEPARATOR}#{result['image_path']}")
					random_helper.remove_by_email(user_email)
				end
				random_helper.insert(user_email, Time.now.to_i.to_s, random_image.image_text, random_image.image_name)
				{status: true, length: 4, info: "/image/verify/#{random_image.image_name}"}.to_json
				#begin
					#random_image = Ash::Utils::CRandomImage.new
					#random_image.picture(user_time, "#{Ash::Disposition::MAIN_DIR_ASSETS_IMAGE}verify#{File::SEPARATOR}")
					#random_helper = Ash::ExtraDB::CRandomImageHelper.new
					#result = random_helper.find_by_email(user_email)
					#pp result
					#if result != nil
						#File.delete("#{Ash::Disposition::MAIN_DIR_ASSETS_IMAGE}verify#{File::SEPARATOR}#{result['image_path']}")
						#random_helper.remove_by_email(user_email)
					#end
					#random_helper.insert(user_email, Time.now.to_i.to_s, random_image.image_text, random_image.image_name)
					#{status: true, length: 4, info: "/image/verify/#{random_image.image_name}"}.to_json
				#rescue
					#puts $!
					#self.integrate_result false, "Unable False"
				#end
			end

			protected
			def user_time?(user_time); (user_time =~ /\d{5,}/) == 0; end

		end
	end
end
