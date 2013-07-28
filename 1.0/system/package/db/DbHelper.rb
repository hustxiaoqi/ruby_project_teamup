#coding: UTF-8

module Ash

	module DB

		class CDBHelper

			attr_reader :collection
			@@collections = ["#{Ash::Disposition::MONGODB_TABLE_PREFIX}member", "#{Ash::Disposition::MONGODB_TABLE_PREFIX}loginRandomImage"]


			def method_missing(method_name, *args)
				method_arr = method_name.to_s.split('_').uniq
				method_length = method_arr.length
				if method_arr.first == 'find' and method_length >= 2
					return self.find_one(args.first, *method_arr[2, method_length]) if method_arr[1] == "one" and method_length >= 3
					return self.find_all(args.first, *method_arr[2, method_length]) if method_arr[1] == "all" and method_length >= 3
					return self.find(args.first, *method_arr[2, method_length])
				end
				super
			end

			def initialize(collection_name, db_name = Ash::Disposition::MONGODB_DBNAME)
				collection_name = self.format_colleation_name collection_name
				raise "collections #{collection_name} not exists" if self.in_collections? collection_name
				
				db_conn = Mongo::MongoClient.new Ash::Disposition::MONGODB_HOSTNAME, Ash::Disposition::MONGODB_PORT
				@collection = db_conn.db(db_name).collection(collection_name)
			end

			public
			def first(*need_key)
				self.find_one({}, *need_key)
			end

			public
			def find_one(query = {}, *need_key)
				fields = {}
				unless need_key.empty?
					need_key.each { |value| fields[value] = 1}
				end
				fields.empty? ? @collection.find_one(query) : @collection.find_one(query, :fields => fields)
			end

			public
			def find_all(*need_key)
				self.find({}, *need_key)
			end

			public
			def find(query = {}, *need_key)
				final, result = [], @collection.find(query).to_a
				unless need_key.empty?
					result.each do |item|
						temp_final = {}
						need_key.each {|value| temp_final[value] = item[value] if item.has_key?(value)}
						final << temp_final.merge({'_id' => item['_id']}).sort
					end
				end
				final.empty? ? result : final
			end

			public
			def last(*args)
				final, result = {}, @collection.find.sort({:numId => :desc}).limit(1).to_a.first
				args.each {|value| final[value] = result[value] if result.has_key?(value)} unless args.empty?
				final.empty? ? result : final.merge({'_id' => result['_id']}).sort
			end

			protected
			def format_colleation_name(collection_name)
				"#{Ash::Disposition::MONGODB_TABLE_PREFIX}#{collection_name}"
			end
			
			protected
			def in_collections?(collection_name)
				nil == @@collections.index(collection_name)
			end

			public
			def insert(insert_value); @collection.insert(insert_value); end

			def remove(query); @collection.remove(query); end

			def update(*query); @collection.update(*query); end

		end

		class DBHelperException

		end
	end
end
