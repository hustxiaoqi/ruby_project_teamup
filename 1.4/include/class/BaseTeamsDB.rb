#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'digest'
require 'pp'
require 'securerandom'
require 'digest'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/config/ConfigCommon.rb"
	require "#{MAIN_PATH}system/package/db/_init.rb"
end

module Ash
	module ExtraDB

		class CBaseTeamsHelper

			attr_reader :helper

			def initialize
				@team_db_name = 'AllTeams'
				@helper = Ash::DB::CDBHelper.new(@team_db_name)
			end

			public
			def team?(tid, uuid)
				result = @helper.find_one({_id: BSON::ObjectId(tid), teamUUId: uuid})
				result.nil? ? false : true
			end

			def governor?(uid, tid)
				result = @help.find_one({_id: BSON::ObjectId(tid)}, 'creatorUid')
				result['creatorUid'].to_s == uid
			end

			protected
			def insert_detailed_team(uid, uuid, name, profile, members, time)
				result = @helper.insert({creatorUid:uid, teamUUId: uuid, teamName: name, teamProfile: profile, particpatingMembers: members, createdProjects: [], createdTime: time, disbandedTime: '', isActive: Ash::Disposition::COMMON_ACTIVE})
				return result if result.nil?
				result.to_s
			end

			def find_teamuuid_by_tid(tid)
				result = @helper.find_one({_id: BSON::ObjectId(tid)}, 'teamUUId')
				result.nil? ? {} : format_result(result)
			end

			private
			def format_result(result)
				raise ArgumentError, "argument error" unless result.is_a? Hash
				final = {}
				final[:team_id] = result['_id'] if result.has_key?('_id')
				final[:uid] = result['creatorUid'] if result.has_key?('creatorUid')
				final[:team_uuid] = result['teamUUId'] if result.has_key?('teamUUId')
				final[:team_name] = result['teamName'] if result.has_key?('teamName')
				final[:team_profile] = result['teamProfile'] if result.has_key?('teamProfile')
				final[:team_members] = result['participatingMembers'] if result.has_key?('participatingMembers')
				final[:team_projects] = result['createdProjects'] if result.has_key?('createdProjects')
				final[:team_created_time] = result['createdTime'] if result.has_key?('createdTime')
				final[:team_disbanded_time] = result['disbandedTime'] if result.has_key?('disbandedTime')
				final[:team_active] = result['isActive'] if result.has_key?('isActive')
				final
			end

		end
	end
end
