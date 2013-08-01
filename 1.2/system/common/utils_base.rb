#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'set'
require 'json'
require 'fileutils'
require 'RMagick'
require 'digest'

module Ash
	module UtilsBase

		def self.email?(email)
			/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/ =~ email ? true : false
		end

		def self.uuid?(uuid)
			uuid =~ /^[0-9a-f]{40}$/ ? true : false
		end

		def self.password?(pwd)
			pwd =~ /^[0-9a-f]{32}$/ ? true : false
		end

		def self.md5_password(pwd = '')
			raise ArgumentError, "md5_password argument error" if pwd.empty?
			Digest::MD5.hexdigest(pwd)
		end

		def self.arr_password?(*pwds)
			raise ArgumentError, "arr_password argument error" if pwds.empty?
			pwds.each {|pwd| return false unless self.password?(pwd)}
			true
		end

		def self.integrate_result(status, type, info)
			{status: status, type: type, info: info}.to_json
		end

		def self.integrate_err_result(type, info)
			self.integrate_result(false, type, info)
		end

		def self.integrate_unable_result
			self.integrate_result(false, Disposition::COMMON_PAGE_ERROR_UNABLE, Disposition::COMMON_PAGE_ERROR_UNABLE_INFO)
		end

		def self.integrate_success_result
			self.integrate_result(true, Disposition::COMMON_PAGE_SUCCESS, Disposition::COMMON_PAGE_SUCCESS_INFO)
		end

		def self.integrate_equal_result(info = '')
			self.integrate_result(true, Disposition::COMMON_PAGE_EQUAL, info)
		end

		def self.chars_zh?(str)
			str =~ /\p{Han}/u ? true: false
		end

	end
end
