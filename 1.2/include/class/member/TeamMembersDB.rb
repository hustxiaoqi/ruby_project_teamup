#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/BaseMembersDB.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}BaseMembersDB.rb"
end

module Ash
	module ExtraDB

		class CTeamMembersHelper < Ash::ExtraDB::CBaseMembersHelper
			
			public
			def find_using_teams(uid)
				team = self.find_all_teams(uid)
				team.each { |item| return item if item[:being_used]} unless team.empty?
				false
			end
		end
	end
end
