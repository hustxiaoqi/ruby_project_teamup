#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}system/common/utils_module.rb"
	require "#{MAIN_PATH}include/config/dir_config.rb"
	require "#{MAIN_PATH}include/config/file_config.rb"
end

include Ash::Disposition


module Ash
	module ModuleApp

		class View
			attr_reader :api

			def initialize(obj_control)
				@api = obj_control
			end

			public
			def load_static_file(file_name, module_name = '')
				self.integrate_xhc_file(file_name, module_name)
			end

			def integrate_xhc_file(file_name, module_name = '')
				if Object.const_defined? :ASH_DEBUG
					file_path = "#{MAIN_PATH}plugin/#{module_name}/#{file_name}"
				else
					file_path = "#{Ash::UtilsModules.module_path}#{file_name}"
				end
				raise "#{file_path} do not exist or not readable" unless File.exist?(file_path) or File.readable?(file_path)
				File.open(file_path).read.to_s
			end

			def integrate_static_file(file_name, module_name = '')
				if Object.const_defined? :ASH_DEBUG
					paths = ["#{MAIN_DIR_ASSETS_HTML}head.html", "#{MAIN_PATH}plugin/#{module_name}/#{file_name}", "#{MAIN_DIR_ASSETS_HTML}bottom.html"]
				else
					paths = ["#{MAIN_DIR_ASSETS_HTML}head.html", "#{Ash::UtilsModules.module_path}#{file_name}", "#{MAIN_DIR_ASSETS_HTML}bottom.html"]
				end
				html = ''
				paths.each do |path|
					raise RuntimeError, "#{path} do not exist or not readable" unless File.exist?(path) or File.readable?(path)
					html << File.open(path).read.to_s
				end
				html
			end

		end
	end
end
