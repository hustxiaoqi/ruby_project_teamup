#coding: UTF-8

require 'set'

module Ash
	module UtilsCommon

		@routing_files = Set.new(Dir.glob("#{Ash::Disposition::MAIN_DIR_ADAPTER_ROUTING}*.rb"))

		def self.load_routing_conf_file
			@routing_files.each do |file|
				require file
			end
		end
	end
end
