#coding: UTF-8

ACCESS_ERROR = true unless Object.const_defined? :ACCESS_ERROR
ASH_DEBUG = true unless Object.const_defined? :ASH_DEBUG
ASH_STRICT_MODE = true unless Object.const_defined? :ASH_STRICT_MODE

MAIN_PATH = File.expand_path('../../../') + '/'

require "#{MAIN_PATH}system/core/.rb"
require 'test/unit'
require 'pp'

class Test < Test::Unit::TestCase

	def test_ok
	end
end
