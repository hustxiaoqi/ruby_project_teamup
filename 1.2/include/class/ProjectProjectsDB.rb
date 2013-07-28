#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/BaseProjectsDB.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}BaseProjectsDB.rb"
end

module Ash
	module ExtraDB

		class CProjectProjectsHelper

			public
			def find_all_part_projects(pid_arr, uid)
				raise ArgumentError, 'find_all_part_projects argument error' if pid_arr.is_a? Array
				pid_arr.each do |pid|
					result = @helper.find_one({_id: BSON::ObjectId(pid)}, 'participatingMembers')
					next if result.nil?
				end
			end
		end
	end
end
