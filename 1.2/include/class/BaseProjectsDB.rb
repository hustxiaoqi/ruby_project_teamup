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

		class CBaseProjectsHelper

			attr_reader :helper

			def initialize
				@team_db_name = 'AllProjects'
				@helper = Ash::DB::CDBHelper.new(@team_db_name)
			end

			protected

			private
			def format_result(result)
				raise ArgumentError, "argument error" unless result.is_a? Hash
				final = {}
				final[:project_id] = result['_id'] if result.has_key?('_id')
				final[:uid] = result['creatorUid'] if result.has_key?('creatorUid')
				final[:project_uuid] = result['projectUUId'] if result.has_key?('projectUUId')
				final[:project_name] = result['prrojectName'] if result.has_key?('projectName')
				final[:project_profile] = result['projectProfile'] if result.has_key?('projectProfile')
				final[:project_members] = result['participatingMembers'] if result.has_key?('participatingMembers')
				final[:project_events] = result['projectEvents'] if result.has_key?('projectEvents')
				final[:project_created_time] = result['createdTime'] if result.has_key?('createdTime')
				final[:project_disbanded_time] = result['disbandedTime'] if result.has_key?('disbandedTime')
				final[:project_active] = result['isActive'] if result.has_key?('isActive')
				final
			end

		end
	end
end
