#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/team/team.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}team#{File::SEPARATOR}team.rb"
end

module Ash
	module ExtraDB

		class TeamSTHelper

			attr_reader :team_helper

			def initialize
				@team_helper = TeamHelper.new
				@team, @db_helper = @team_helper.team, @team_helper.helper
			end
			
			public
			def init_team(tid)
				@team.id = tid
				self
			end

			def find_team_briefs
				result = @team_helper.find_all_by_tid(@team.id)
				result.nil? ? nil : result.team
			end
		end
	end
end
