#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/team/team.rb"
	require "#{MAIN_PATH}include/config/common_config.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}team#{File::SEPARATOR}team.rb"
end

require 'digest'
require 'securerandom'

module Ash
	module ExtraDB

		class RegisterTHelper

			attr_reader :team_helper

			def initialize
				@team_helper = TeamHelper.new
				@team, @db_helper = @team_helper.team, @team_helper.helper
			end

			public
			def init_team(uid, name)
				@team.creator_id, @team.name = uid, name
				self
			end

			def insert_briefs
				@db_helper.insert({briefIntroduction: '', createdProjects: [], createdTime: Time.now.to_i.to_s, creatorUid: @team.creator_id, disbandedTime: '', isActive: Disposition::COMMON_ACTIVE.to_s, isForzen: Disposition::COMMON_NOT_FORZEN.to_s, particpatingMembers: [], teamName: @team.name, teamProfile: '', teamUUId: Digest::SHA1.hexdigest(SecureRandom.uuid)}).to_s
			end


		end
	end
end
