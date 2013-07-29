#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/member/member.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}member#{File::SEPARATOR}member.rb"
end

module Ash
	module ExtraDB

		class TeamMHelper

			def initialize
				@member_helper = MemberHelper.new
				@member, @db_helper = @member_helper.member, @member_helper.helper
			end
			
			public
			def find_using_teams
				result = @member_helper.find_all_by_uid
				return nil if result.nil? or result.member.teams.empty?
				result.member.teams.each { |team| return team if team.being_used == Ash::Disposition::COMMON_ACTIVE.to_s}
				result.member.teams.first
			end

			def init_member(uid)
				@member.id = uid
				self
			end
		end
	end
end
