#coding: UTF-8

ACCESS_ERROR ||= true

require 'test/unit'
require './ClassRandomImageDB.rb'
require 'pp'
require '../../system/package/db/_init.rb'

class TestClassRandomImageDB < Test::Unit::TestCase
	def test_insert
		pp Ash::ExtraDB::CRandomImageHelper.new.insert()
		pp Ash::ExtraDB::CRandomImageHelper.new.insert('pp')
		pp Ash::ExtraDB::CRandomImageHelper.new.insert({name: 'chuangwang'})
	end
end

#module Ash
	#module ExtraDB

		#class CRandomImageHelper

			#def initialize
				#@helper = Ash::DB::CDBHelper.new('randomImage')
				#@collection = @helper.collection
			#end

			#public
			#def insert(email, start_time, text)
				#@collection.insert({:email => email, :startTime => start_time, :token => text})
			#end

			#public
			#def find(email)
				#@helper.find_one({:email => email}, 'startTime', 'token')
			#end
		#end
	#end
#end
