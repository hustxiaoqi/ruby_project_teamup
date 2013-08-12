#coding: UTF-8

require 'pp'
require 'sinatra'

ACCESS_ERROR = true unless Object.const_defined? :ACCESS_ERROR

ASH_MODE_CLIENT = 7
ASH_MODE_DEV = 77

# develpement mode
ASH_MODE = ASH_MODE_DEV

MAIN_PATH = File.expand_path(File.dirname(__FILE__)) << File::SEPARATOR
Dir.chdir MAIN_PATH

SYS_PATH = "#{MAIN_PATH}system#{File::SEPARATOR}"

raise "#{SYS_PATH} not exist" unless File.directory? SYS_PATH

begin
	require "#{SYS_PATH}SysIndex.rb"
rescue  LoadError => error
	puts error.message
	puts error.backtrace.join("\n")
end
