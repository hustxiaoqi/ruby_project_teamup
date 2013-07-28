#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR
require "#{Ash::Disposition::MAIN_DIR_INCLUDE_CONFIG}ConfigDB#{FILE_EXT}"

require "#{Ash::Disposition::SYS_DIR_PACKAGE}db#{File::SEPARATOR}DbHelper#{FILE_EXT}"
