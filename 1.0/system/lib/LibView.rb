#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

module Ash
	module ModuleApp

		class CView
			attr_reader :api

			def initialize(obj_control)
				@api = obj_control
			end

			public
			def load_static_file(file_name)
				file_path = "#{Ash::UtilsModules.module_path}#{file_name}"
				raise "#{file_path} do not exist or not readable" unless File.exist?(file_path) or File.readable?(file_path)
				File.open(file_path).read.to_s
			end
		end
	end
end
