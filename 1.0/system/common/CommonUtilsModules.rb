#coding: UTF-8
require 'pp'

module Ash
	module UtilsModules

		def self.load_module_files(module_name)
			@module_name = module_name.downcase
			@module_path = Ash::Disposition::MAIN_DIR_PLUGIN + @module_name + File::SEPARATOR
			@module_view_file, @module_control_file = "#{@module_path + @module_name.capitalize}View#{FILE_EXT}", "#{@module_path + @module_name.capitalize}Control#{FILE_EXT}"
			raise "#{@module_name} modules do not exist" unless Dir.exists? @module_path
			raise "#{@module_view_file} file do not exist" unless File.exist? @module_view_file
			raise "#{@module_control_file} file do not exist" unless File.exist? @module_control_file
			require @module_view_file
			require @module_control_file
		end

		def self.module_name
			@module_name
		end

		def self.module_path
			@module_path
		end

		def self.display_module_outline(request, function = 'default', params = [])
			puts "Request\t\t=> #{request.request_method} #{request.url} #{request.ip}\n"
			puts "File\t\t=> #{@module_view_file}"
			puts "Function\t=> Ash::ModuleApp::CView#{@module_name}.new.#{function}\n"
			puts "Params\t\t=> #{params}"
			puts "Time\t\t=> #{Time.now.gmtime}"
		end
	end
end
