require 'pp'
require 'sinatra'

ACCESS_ERROR ||= true

FILE_EXT ||= '.rb'

MAIN_PATH = File.expand_path(File.dirname(__FILE__)) << File::SEPARATOR
Dir.chdir MAIN_PATH

SYS_PATH = "#{MAIN_PATH}system#{File::SEPARATOR}"

raise "#{SYS_PATH} not exist" unless File.directory? SYS_PATH

begin
	require "#{SYS_PATH}SysIndex#{FILE_EXT}"
rescue  LoadError => error
	pp error.message
	puts error.backtrace.join("\n")
end
