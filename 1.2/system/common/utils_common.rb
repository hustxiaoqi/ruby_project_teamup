#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'set'

module Ash
	module UtilsCommon


		def self.load_routing_conf_files
			routing_files = Set.new(Dir.glob("#{Ash::Disposition::MAIN_DIR_ADAPTER}*.rb"))
			routing_files.each {|file| require file}
		end

		def self.load_config_files
			config_files = Set.new(Dir.glob("#{Ash::Disposition::MAIN_DIR_INCLUDE_CONFIG}*.rb"))
			config_files.each {|file| require file}
		end

		def self.format_member_profile_path(profile)
			base_path = "/image/user_gallery/"
			profile.empty? ? (base_path + Ash::Disposition::COMMON_MEMBER_PHOTO_DEFAULT_FILE) : (base_path + profile)
		end

	end
end
