#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'set'
require 'json'

module Ash
	module UtilsBase

		def self.email?(email)
			/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/ =~ email ? true : false
		end

		def self.uuid?(uuid)
			uuid =~ /^[0-9a-f]{40}$/ ? true : false
		end

		def self.integrate_result(status, type, info)
			{status: status, type: type, info: info}.to_json
		end

		def self.integrate_unable_eresult
			self.integrate_result(false, Ash::Disposition::COMMON_PAGE_ERROR_UNABLE, Ash::Disposition::COMMON_PAGE_ERROR_UNABLE_INFO)
		end

		def self.integrate_success_result
			self.integrate_result(true, Ash::Disposition::COMMON_PAGE_SUCCESS, Ash::Disposition::COMMON_PAGE_SUCCESS_INFO)
		end

		def self.chars_zh?(str)
			str =~ /\p{Han}/u ? true: false
		end
	end
end
