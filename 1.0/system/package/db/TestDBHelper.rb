require 'test/unit'
require './_init.rb'
require 'pp'


class TestDBHelpper < Test::Unit::TestCase
	def test_first_1
		pp Ash::DB::CDBHelper.new('user').first
	end
	def test_first_2
		pp Ash::DB::CDBHelper.new('user').first('userId')
	end

	def test_last_1
		pp Ash::DB::CDBHelper.new('user').last
	end
	def test_last_2
		pp Ash::DB::CDBHelper.new('user').last('userId')
	end

	def test_find_one_1
		pp Ash::DB::CDBHelper.new('user').find_one
		pp Ash::DB::CDBHelper.new('user').find_one({'userId' => 'U201113770'})
		pp Ash::DB::CDBHelper.new('user').find_one({'userId' => 'U201113760'}, 'userId', 'numId')
	end

	def test_find_all
		pp Ash::DB::CDBHelper.new('user').find_all
	end

	def test_find
		pp Ash::DB::CDBHelper.new('user').find
		pp Ash::DB::CDBHelper.new('user').find({'userId' => 'U201113770'})
		pp Ash::DB::CDBHelper.new('user').find({'userId' => 'U201113760'}, 'userId', 'numId')
		pp Ash::DB::CDBHelper.new('user').find({}, 'userId', 'numId')
	end
end
