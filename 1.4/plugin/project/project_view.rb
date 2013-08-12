#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/core/view.rb"
	require "#{MAIN_PATH}plugin/project/project_control.rb"
	require "#{MAIN_PATH}include/config/file_config.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}view.rb"
	require "#{Ash::Disposition::MAIN_DIR_PLUGIN}project#{File::SEPARATOR}project_control.rb"
end

require 'json'
require 'erb'

module Ash
	module ModuleApp
		
		class ProjectView < Ash::ModuleApp::View
			
			def initialize
				super(Ash::ModuleApp::ProjectControl.new)
			end
			
			def default(*args)
				#ct_result = @api.ct_default(*args)
				#return {status: false, info: 'Unable Error', type: '1'}.to_json unless ct_result.is_a? Array
				#governor, projects = ct_result.first, ct_result.last
				#html_body = ERB.new(File.open("#{Ash::Disposition::MAIN_DIR_PLUGIN}project#{File::SEPARATOR}project.rhtml").read).result(binding)
				#html_head, html_bottom = File.open("#{Ash::Disposition::MAIN_FILE_HTML_HEAD}").read, File.open("#{Ash::Disposition::MAIN_FILE_HTML_BOTTOM}").read
				#html_head + html_body + html_bottom
				html_head, html_bottom = File.open("#{Ash::Disposition::MAIN_FILE_HTML_HEAD}").read, File.open("#{Ash::Disposition::MAIN_FILE_HTML_BOTTOM}").read
				html_head + html_bottom

			end

			#def view_ajax_newproject(*args)
				#user_info_arr = @api.ct_ajax_newproject(*args)
				#return {status: false, info: 'Unable Error', type: '1'}.to_json unless user_info_arr.is_a? Array
				#ERB.new(File.open("#{Ash::Disposition::MAIN_DIR_PLUGIN}project#{File::SEPARATOR}new_project.rhtml").read).result(binding)
			#end

			#def view_newproject(*args)
				#user_info_arr = @api.ct_ajax_newproject(*args)
				#return {status: false, info: 'Unable Error', type: '1'}.to_json unless user_info_arr.is_a? Array

				#html_body = ERB.new(File.open("#{Ash::Disposition::MAIN_DIR_PLUGIN}project#{File::SEPARATOR}new_project.rhtml").read).result(binding)
				#html_head, html_bottom = File.open("#{Ash::Disposition::MAIN_FILE_HTML_HEAD}").read, File.open("#{Ash::Disposition::MAIN_FILE_HTML_BOTTOM}").read
				#html_head + html_body + html_bottom

			#end

			#def view_verify_newproject(*args)
				#@api.ct_verify_newproject(*args)
			#end

		end
	end
end
