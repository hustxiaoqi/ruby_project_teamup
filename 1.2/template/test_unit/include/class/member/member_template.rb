#coding: UTF-8

ACCESS_ERROR = true unless Object.const_defined? :ACCESS_ERROR
ASH_DEBUG = true unless Object.const_defined? :ASH_DEBUG
ASH_STRICT_MODE = true unless Object.const_defined? :ASH_STRICT_MODE

MAIN_PATH = File.expand_path('../../../../') + '/'

require "#{MAIN_PATH}include/class/member/member.rb"
require 'test/unit'
require 'pp'

class TestMember < Test::Unit::TestCase


end
