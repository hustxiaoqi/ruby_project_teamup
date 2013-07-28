#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/BaseMembersDB.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}BaseMembersDB.rb"
end

module Ash
	module ExtraDB

		class CProjectMembersHelper < Ash::ExtraDB::CBaseMembersHelper

			public
			def find_all_user_infos(uid_arr)
				uid_arr = [uid_arr] unless uid_arr.is_a? Array
				user_info_arr = []
				uid_arr.each do |uid|
					user_info = @helper.find_one({_id: BSON::ObjectId(uid)}, 'email', 'gallery', 'memberName')
					if user_info.nil?
						raise RuntimeError, "UID do not exists!" if Object.const_defined? :ASH_STRICT_MODE
					end
					user_info_arr << format_result(user_info)
				end
				user_info_arr
			end
		end
	end
end
