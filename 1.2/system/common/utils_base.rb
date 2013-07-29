#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'set'

module Ash
	module UtilsBase

		def self.email?(email)
			/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/ =~ email ? true : false
		end

		def self.uuid?(uuid)
			uuid =~ /^[0-9a-f]{40}$/ ? true : false
		end
	end
end
