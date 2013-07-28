#encoding: UTF-8

exit unless defined? ACCESS_ERROR

require 'sinatra'
require 'pp'

begin

  require "#{SYS_PATH}config#{File::SEPARATOR}ConfigDirectory#{FILE_EXT}"
  require "#{Ash::Disposition::SYS_DIR_CONFIG}ConfigFile#{FILE_EXT}"

  require "#{MAIN_PATH}include#{File::SEPARATOR}config#{File::SEPARATOR}ConfigDirectory#{FILE_EXT}"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CONFIG}ConfigCommon#{FILE_EXT}"

	require "#{Ash::Disposition::MAIN_DIR_ADAPTER}AdapterBefore#{FILE_EXT}"
	require "#{Ash::Disposition::MAIN_DIR_ADAPTER}AdapterSession#{FILE_EXT}"

  require "#{Ash::Disposition::SYS_DIR_COMMON}CommonUtils#{FILE_EXT}"
	Ash::UtilsCommon.load_routing_conf_file

  require "#{Ash::Disposition::SYS_DIR_COMMON}CommonUtilsModules#{FILE_EXT}"
  require "#{Ash::Disposition::SYS_DIR_PACKAGE}db#{File::SEPARATOR}_init#{FILE_EXT}"

	#require "#{Ash::Disposition::SYS_DIR_LIB}BaseAppLib#{FILE_EXT}"
rescue LoadError => error
	puts error.to_s, error.backtrace.join('\n')
	puts "Local variable #{local_variables}"
end

#Ash::Disposition.constants.each do |cont|
	#pp "Ash::Disposition::#{cont} => " << Object.const_get("Ash::Disposition::#{cont}")
#end

#Module.constants.each {|value| puts "#{value} ==> #{Module.const_get value}"}
