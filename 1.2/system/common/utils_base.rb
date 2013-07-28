#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'set'

module Ash
	module UtilsBase

		def self.email?(email)
			(/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/ =~ email) == 0
		end
	end
end
