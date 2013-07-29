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
			def initialize(*args)
				return if args.empty?
				raise MemberException, "Member initialize argument error" unless args.length == 1
				args.first.each { |key, value| eval("@#{key}=value")}
			end
		end

		class MemberPTeams
			attr_accessor :id, :authority, :join_time, :quit_time, :being_used
			def initialize(*args)
				return if args.empty?
				raise MemberException, "MemberPTeams initialize argument error" unless args.length == 1
				args.first.each { |key, value| eval("@#{key}=value")}
			end
		end

		class MemberResult

			attr_reader :member

			def initialize(members)
				@member = []
				members = [members] unless members.is_a? Array
				members.each do |member|
					raise MemberException, "MemberResult initialize argument error" unless member.is_a? Hash
					@member << Member.new(
						id: member.has_key?('_id') ? member['_id'].to_s : nil,
						introduction: member.has_key?('briefIntroduction') ? member['briefIntroduction'] : nil,
						email: member.has_key?('email') ? member['email'] : nil,
						active: member.has_key?('isActive') ? member['isActive'] : nil,
						frozen: member.has_key?('isFrozen') ? member['isFrozen'] : nil,
						name: member.has_key?('memberName') ? member['memberName'] : nil,
						profile: member.has_key?('memberProfile') ? member['memberProfile'] : nil,
						uuid: member.has_key?('memberUUId') ? member['memberUUId'] : nil,
						teams: member.has_key?('participatingTeams') ? self.init_teams(member['participatingTeams']) : nil,
						password: member.has_key?('passwordMD5') ? member['passwordMD5'] : nil,
					)
				end
				@member = @member.first  if @member.length == 1

			end

			def init_teams(teams)
				teams = [teams] unless teams.is_a? Array
				team_arr = []
				teams.each do |team|
					raise MemberException, "MemberResult initialize argument error" unless team.is_a? Hash
					team_arr << MemberPTeams.new(
						id: team.has_key?('teamId') ? team['teamId'] : nil,
						authority: team.has_key?('teamAuthority') ? team['teamAuthority'] : nil,
						join_time: team.has_key?('teamJoinTime') ? team['teamJoinTime'] : nil,
						quit_time: team.has_key?('teamQuitTime') ? team['teamQuitTime'] : nil,
						being_used: team.has_key?('beingUsed') ? team['beingUsed'] : nil,
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

			def find_all_by_email
				raise MemberException, "email error" if @member.email.nil? or !Ash::UtilsBase.email?(@member.email)
				result = @helper.find_one({email: @member.email})
				return result if result.nil?
				MemberResult.new(result)
			end

			def find_all_by_uid
				raise MemberException, "uid error" if @member.id.nil? or !BSON::ObjectId.legal?(@member.id)
				result = @helper.find_one({_id: BSON::ObjectId(@member.id)})
				return result if result.nil?
				MemberResult.new(result)
			end
		end

		class MemberException < StandardError; end
	end
end
