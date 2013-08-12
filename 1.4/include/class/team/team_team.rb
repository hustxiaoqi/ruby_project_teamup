#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/team/team.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}team#{File::SEPARATOR}team.rb"
end

module Ash
	module ExtraDB

		class TeamTHelper

			def initialize
				@team_helper = TeamHelper.new
				@team, @db_helper = @team_helper.team, @team_helper.helper
			end
			
			public
			def find_uuid_by_ttid
				result = @team_helper.find_all_by_tid
				return result if result.nil?
				result.team.uuid
			end

			def init_team(tid)
				@team.id = tid
				self
			end
		end
	end
end
