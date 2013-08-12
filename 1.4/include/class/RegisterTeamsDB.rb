#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/class/BaseTeamsDB.rb"
else
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CLASS}BaseTeamsDB.rb"
end

require 'securerandom'
require 'digest'

module Ash
	module ExtraDB

		class CRegisterTeamsHelper < Ash::ExtraDB::CBaseTeamsHelper

			public
			def create_brief_team(uid, name)
				self.insert_detailed_team(uid, Digest::SHA1.hexdigest(SecureRandom.uuid), name, '', [], Time.now.to_i.to_s)
			end

		end

	end
end
