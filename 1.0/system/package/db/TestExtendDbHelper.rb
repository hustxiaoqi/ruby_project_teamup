#coding: UTF-8
require 'test/unit'
require 'pp'
require './_init.rb'

module Ash
	module DB

		class CExtendDbHelper < Ash::DB::CDBHelper

			def initialize
				super('user')
			end

		end
	end
end

class TestExtendDbHelper < Test::Unit::TestCase
	def test_find_one
		pp Ash::DB::CExtendDbHelper.new.find_one_numId({'userId' => 'U201113771'})
		pp Ash::DB::CExtendDbHelper.new.find_one({'userId' => 'U201113771'})
		pp Ash::DB::CExtendDbHelper.new.find_one_numId_passwordMD5({'userId' => 'U201113771'})
	end
	def test_find
		pp Ash::DB::CExtendDbHelper.new.find_numId_passwordMD5()
	end
end
