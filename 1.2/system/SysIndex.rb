#encoding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'sinatra'

require "#{MAIN_PATH}include#{File::SEPARATOR}config#{File::SEPARATOR}dir_config.rb"

include Ash::Disposition

require "#{MAIN_DIR_INCLUDE_CONFIG}file_config.rb"
require "#{MAIN_DIR_INCLUDE_CONFIG}common_config.rb"
require "#{MAIN_DIR_INCLUDE_CONFIG}db_config.rb"

require "#{SYS_DIR_COMMON}utils_common.rb"
Ash::UtilsCommon.load_routing_conf_files

require "#{SYS_DIR_COMMON}utils_module.rb"
require "#{SYS_DIR_COMMON}utils_base.rb"
#require "#{SYS_DIR_PACKAGE}db#{File::SEPARATOR}_init.rb"

#Ash::Disposition.constants.each do |cont|
	#pp "Ash::Disposition::#{cont} => " << Object.const_get("Ash::Disposition::#{cont}")
#end

#Module.constants.each {|value| puts "#{value} ==> #{Module.const_get value}"}
