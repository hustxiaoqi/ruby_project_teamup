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
			def initialize(*args)
				return if args.empty?
				raise TeamException, "Member initialize argument error" unless args.length == 1
				args.first.each { |key, value| eval("@#{key}=value")}
			end
		end

		class TeamCProjects
			attr_accessor :id
			def initialize(*args)
				return if args.empty?
				raise TeamException, "MemberPTeams initialize argument error" unless args.length == 1
				args.first.each { |key, value| eval("@#{key}=value")}
			end
		end

		class TeamPMembers
			attr_accessor :id, :authority, :join_time, :quit_time, :frozen
			def initialize(*args)
				return if args.empty?
				raise TeamException, "MemberPTeams initialize argument error" unless args.length == 1
				args.first.each { |key, value| eval("@#{key}=value")}
			end
		end

		class TeamResult

			attr_reader :team

			def initialize(teams)
				@team = []
				teams = [teams] unless teams.is_a? Array
				teams.each do |team|
					raise TeamException, "MemberResult initialize argument error" unless team.is_a? Hash
					@team << Team.new(
						id: team.has_key?('_id') ? team['_id'].to_s : nil,
						introduction: team.has_key?('briefIntroduction') ? team['briefIntroduction'] : nil,
						projects: team.has_key?('createdProjects') ? self.init_projects(team['createdProjects']) : nil,
						created_time: team.has_key?('createdTime') ? team['createdTime'] : nil,
						creator_id: team.has_key?('creatorUid') ? team['creatorUid'] : nil,
						disbanded_time: team.has_key?('disbandedTime') ? team['disbandedTime'] : nil,
						active: team.has_key?('isActive') ? team['isActive'].to_s : nil,
						members: team.has_key?('participatingMembers') ? self.init_members(team['participatingMembers']) : nil,
						name: team.has_key?('teamName') ? team['teamName'] : nil,
						profile: team.has_key?('teamProfile') ? team['teamProfile'] : nil,
						uuid: team.has_key?('teamUUId') ? team['teamUUId'] : nil,
					)
				end
				@team = @team.first  if @team.length == 1
			end

			protected
			def init_projects(projects)
				projects = [projects] unless projects.is_a? Array
				project_arr = []
				projects.each do |project|
					raise TeamException, "MemberResult initialize argument error" unless project.is_a? Hash
					project_arr << TeamCProjects.new(
						id: project.has_key?('projectId') ? project['projectId'] : nil,
						#authority: project.has_key?('projectAuthority') ? project['projectAuthority'] : nil,
						#join_time: project.has_key?('projectJoinTime') ? project['projectJoinTime'] : nil,
						#quit_time: project.has_key?('projectQuitTime') ? project['projectQuitTime'] : nil,
						#being_used: project.has_key?('beingUsed') ? project['beingUsed'] : nil,
					)
				end
				project_arr
			end

			def init_members(members)
				members = [members] unless members.is_a? Array
				member_arr = []
				members.each do |member|
					raise TeamException, "MemberResult initialize argument error" unless member.is_a? Hash
					member_arr << TeamPMembers.new(
						id: member.has_key?('memberId') ? member['memberId'] : nil,
						authority: member.has_key?('memberAuthority') ? member['memberAuthority'] : nil,
						join_time: member.has_key?('memberJoinTime') ? member['memberJoinTime'] : nil,
						quit_time: member.has_key?('memberQuitTime') ? member['memberQuitTime'] : nil,
						frozen: member.has_key?('isFrozen') ? member['isFrozen'] : nil,
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

			def find_all_by_tid
				raise TeamException, "tid error" if @team.id.nil? or !BSON::ObjectId.legal?(@team.id)
				result = @helper.find_one({_id: BSON::ObjectId(@team.id)})
				return result if result.nil?
				TeamResult.new(result)
			end

			def team?
				raise TeamException, "tid error" if @team.id.nil? or !BSON::ObjectId.legal?(@team.id)
				raise TeamException, "uuid error" if @team.uuid.nil? or !Ash::UtilsBase.uuid? @team.uuid
				@helper.find_one({_id: BSON::ObjectId(@team.id), teamUUId: @team.uuid}) != nil
			end
		end

		class TeamException < StandardError; end
	end
end
