#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'digest'
require 'securerandom'
require 'digest'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/config/common_config.rb"
	require "#{MAIN_PATH}system/core/db_helper.rb"
	require "#{MAIN_PATH}system/common/utils_base.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}db_helper.rb"
	require "#{Ash::Disposition::SYS_DIR_COMMON}utils_base.rb"
end

module Ash
	module ExtraDB

		class Member
			attr_accessor :id, :introduction, :email, :active, :frozen, :name, :profile, :uuid, :teams, :password
			def initialize(args = {})
				raise TeamException, "Member initialize argument error" unless args.is_a? Hash
				args.map { |key, value| instance_variable_set("@#{key}", value)} unless args.empty?
			end
		end

		class MemberPTeams
			attr_accessor :id, :authority, :join_time, :quit_time, :being_used
			def initialize(args = {})
				raise TeamException, "MemberPTeams initialize argument error" unless args.is_a? Hash
				args.map { |key, value| instance_variable_set("@#{key}", value)} unless args.empty?
			end
		end

		class MemberResult

			attr_reader :member

			def initialize(members)
				@member = []
				members = [members] unless members.is_a? Array
				members.map do |member|
					raise MemberException, "MemberResult initialize argument error" unless member.is_a? Hash
					@member << Member.new(
						id: member['_id'].to_s || nil,
						introduction: member['briefIntroduction'] || nil,
						email: member['email'] || nil,
						active: member['isActive'] || nil,
						frozen: member['isFrozen'] || nil,
						name: member['memberName'] || nil,
						profile: member['memberProfile'] || nil,
						uuid: member['memberUUId'] || nil,
						teams: member.has_key?('participatingTeams') ? self.init_teams(member['participatingTeams']) : nil,
						password: member['passwordMD5'] || nil,
					)
				end
				@member = @member.first  if @member.length == 1

			end

			def init_teams(teams)
				teams = [teams] unless teams.is_a? Array
				team_arr = []
				teams.map do |team|
					raise MemberException, "MemberResult initialize argument error" unless team.is_a? Hash
					team_arr << MemberPTeams.new(
						id: team['teamId'] || nil,
						authority: team['teamAuthority'] || nil,
						join_time: team['teamJoinTime'] || nil,
						quit_time: team['teamQuitTime'] || nil,
						being_used: team['beingUsed'] || nil,
					)
				end
				team_arr
			end

		end

		class MemberHelper
			attr_accessor :member
			attr_reader :helper

			def initialize
				@member_db_name = 'AuthMembers'
				@helper = Ash::DB::DBHelper.new(@member_db_name)
				@member = Member.new
			end

			def member?(mid = nil)
				@member.id = mid unless mid.nil?
				raise MemberException, "uid error" if @member.id.nil? or !BSON::ObjectId.legal?(@member.id)
				!@helper.find_one({_id: BSON::ObjectId(@member.id)}).nil?
			end

			def find_all_by_email(email = nil)
				@member.email = email unless email.nil?
				raise MemberException, "email error" if @member.email.nil? or !Ash::UtilsBase.email?(@member.email)
				result = @helper.find_one({email: @member.email})
				return result if result.nil?
				MemberResult.new(result)
			end

			def find_all_by_uid(uid = nil)
				@member.id = uid unless uid.nil?
				raise MemberException, "uid error" if @member.id.nil? or !BSON::ObjectId.legal?(@member.id)
				result = @helper.find_one({_id: BSON::ObjectId(@member.id)})
				return result if result.nil?
				MemberResult.new(result)
			end
		end

		class MemberException < StandardError; end
	end
end
