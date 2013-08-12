#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/team/team.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}team#{File::SEPARATOR}team.rb"
end

module Ash
	module ExtraDB

		class ProjectTHelper

			attr_reader :team_helper

			def initialize
				@team_helper = TeamHelper.new
				@team, @db_helper = @team_helper.team, @team_helper.helper
			end

			public
			def init_team(tid, tuuid)
				@team.id, @team.uuid = tid, uuid
				self
			end

			def governor?(auth)
				auth == Ash::Disposition::COMMON_TEAM_CREATE_AUTHORITY or auth == Ash::Disposition::COMMON_TEAM_MANAGE_AUTHORITY
			end

			def find_all_projects
				result = @team_helper.find_all_by_tid
				return result if result.nil?
				result.team.projects
			end

		end
	end
end
