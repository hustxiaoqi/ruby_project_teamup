#coding: UTF-8

require 'mongo'

module Ash

	module Disposition 

		MONGODB_HOSTNAME = ENV['ASH_MONGODB_HOSTNAME'] || 'localhost'
		MONGODB_PORT = ENV['ASH_MONGODB_PORT'] || Mongo::MongoClient::DEFAULT_PORT
		MONGODB_DBNAME = 'ash_uniquestudio_tower'
		MONGODB_TABLE_PREFIX = 'dev_'

	end
end
