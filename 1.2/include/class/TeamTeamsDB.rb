#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/BaseTeamsDB.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}BaseTeamsDB.rb"
end

module Ash
	module ExtraDB

		class CTeamTeamsHelper < Ash::ExtraDB::CBaseTeamsHelper

			public
			def find_uuid_by_ttid(ttid)
				result = self.find_teamuuid_by_tid(ttid)
				result.empty? ? false : result[:team_uuid]
			end

		end
	end
end
