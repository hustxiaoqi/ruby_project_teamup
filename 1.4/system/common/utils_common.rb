#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'set'
require 'fileutils'

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/config/dir_config.rb"
end

module Ash
	module UtilsCommon

		def self.dev_mode?
			ASH_MODE == ASH_MODE_DEV
		end

		def self.load_routing_conf_files
			routing_files = Set.new(Dir.glob("#{Disposition::MAIN_DIR_ADAPTER}*.rb"))
			routing_files.each {|file| require file}
		end

		def self.load_config_files
			config_files = Set.new(Dir.glob("#{Disposition::MAIN_DIR_INCLUDE_CONFIG}*.rb"))
			config_files.each {|file| require file}
		end

		def self.format_member_profile_path(profile)
			base_path = "/image/user_gallery/"
			profile.empty? ? (base_path + Disposition::COMMON_MEMBER_PHOTO_DEFAULT_FILE) : (base_path + profile)
		end

		def self.real_img_content_type(file_path)
			Magick::ImageList.new(file_path).format
		end

		def self.profile?(file_path)
			Disposition::COMMON_USING_IMAGE_TYPES.include?(self.real_img_content_type(file_path))
		end

		def self.copy_image(src, des)
			FileUtils.copy(src, des)
		end

		def self.format_image_name(uid, size = 100)
			raise ArgumentError, "format_image_name size argument error" unless size.is_a? Fixnum
			Digest::MD5.hexdigest(uid) + "_#{size}_#{size}.png"
		end

		def self.format_image(srcpath, despath)
			raise RuntimeError, "#{srcpath} not file" unless File.file?(srcpath)
			img = Magick::Image.read(srcpath).first
			thumb = img.resize(Disposition::COMMON_USING_IMAGE_WIDTH, Disposition::COMMON_USING_IMAGE_HEIGHT)
			thumb.write(despath)
		end

		def self.delete_random_image(path)
			path = Disposition::MAIN_DIR_ASSETS_IMAGE + 'verify' + File::SEPARATOR + path
			!File.file?(path) and raise ArgumentError, "delete_random_image argument error" 
			File.delete path
		end

	end
end
