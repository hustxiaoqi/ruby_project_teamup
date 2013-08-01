#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'digest'
require 'securerandom'
require 'digest'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/config/common_config.rb"
	require "#{MAIN_PATH}system/core/db_helper.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}db_helper.rb"
end

module Ash
	module ExtraDB

		class Team
			attr_accessor :id, :introduction, :projects, :created_time, :creator_id, :disbanded_time, :active, :members, :name, :profile, :uuid
			def initialize(args = {})
				raise TeamException, "Team initialize argument error" unless args.is_a? Hash
				args.map { |key, value| instance_variable_set("@#{key}", value)} unless args.empty?
			end
		end

		class TeamCProjects
			attr_accessor :id
			def initialize(args = {})
				raise TeamException, "TeamCProjects initialize argument error" unless args.is_a? Hash
				args.map { |key, value| instance_variable_set("@#{key}", value)} unless args.empty?
			end
		end

		class TeamPMembers
			attr_accessor :id, :authority, :join_time, :quit_time, :frozen
			def initialize(args = {})
				raise TeamException, "TeamPMembers initialize argument error" unless args.is_a? Hash
				args.map { |key, value| instance_variable_set("@#{key}", value)} unless args.empty?
			end
		end

		class TeamResult

			attr_reader :team

			def initialize(teams)
				@team = []
				teams = [teams] unless teams.is_a? Array
				teams.map do |team|
					raise TeamException, "MemberResult initialize argument error" unless team.is_a? Hash
					@team << Team.new(
						id: team['_id'].to_s || nil,
						introduction: team['briefIntroduction'] || nil,
						projects: team.has_key?('createdProjects') ? self.init_projects(team['createdProjects']) : nil,
						created_time: team['createdTime'] || nil,
						creator_id: team['creatorUid'] || nil,
						disbanded_time: team['disbandedTime'] || nil,
						active: team['isActive'].to_s || nil,
						members: team.has_key?('participatingMembers') ? self.init_members(team['participatingMembers']) : nil,
						name: team['teamName'] || nil,
						profile: team['teamProfile'] || nil,
						uuid: team['teamUUId'] || nil,
					)
				end
				@team = @team.first  if @team.length == 1
			end

			protected
			def init_projects(projects)
				projects = [projects] unless projects.is_a? Array
				project_arr = []
				projects.map do |project|
					raise TeamException, "MemberResult initialize argument error" unless project.is_a? Hash
					project_arr << TeamCProjects.new(
						id: project['projectId'] || nil,
						#authority: project['projectAuthority'] || nil,
						#join_time: project['projectJoinTime'] || nil,
						#quit_time: project['projectQuitTime'] || nil,
						#being_used: project['beingUsed'] || nil,
					)
				end
				project_arr
			end

			def init_members(members)
				members = [members] unless members.is_a? Array
				member_arr = []
				members.map do |member|
					raise TeamException, "MemberResult initialize argument error" unless member.is_a? Hash
					member_arr << TeamPMembers.new(
						id: member['memberId'] || nil,
						authority: member['memberAuthority'] || nil,
						join_time: member['memberJoinTime'] || nil,
						quit_time: member['memberQuitTime'] || nil,
						frozen: member['isFrozen'] || nil,
					)
				end
				member_arr
			end

		end

		class TeamHelper
			attr_accessor :team
			attr_reader :helper

			def initialize
				@team_db_name = 'AllTeams'
				@helper = Ash::DB::DBHelper.new(@team_db_name)
				@team = Team.new
			end

			def find_all_by_tid(tid = nil)
				@team.id = tid unless tid.nil?
				raise TeamException, "tid error" if @team.id.nil? or !BSON::ObjectId.legal?(@team.id)
				result = @helper.find_one({_id: BSON::ObjectId(@team.id)})
				return result if result.nil?
				TeamResult.new(result)
			end

			def team?(tid = nil, uuid = nil)
				@team.id, @team.uuid = tid, uuid unless tid.nil? and uuid.nil?
				raise TeamException, "tid error" if @team.id.nil? or !BSON::ObjectId.legal?(@team.id)
				raise TeamException, "uuid error" if @team.uuid.nil? or !UtilsBase.uuid? @team.uuid
				!@helper.find_one({_id: BSON::ObjectId(@team.id), teamUUId: @team.uuid}).nil?
			end

			class << self
				def governor?(auth)
					auth == COMMON_TEAM_CREATE_AUTHORITY.to_s or auth == COMMON_TEAM_MANAGE_AUTHORITY.to_s
				end
			end
		
		end

		class TeamException < StandardError; end
	end
end
