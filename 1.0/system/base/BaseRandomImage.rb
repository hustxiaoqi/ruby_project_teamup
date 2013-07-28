#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'securerandom'
require 'RMagick'

module Ash
	module Utils

		class CRandomImage

			attr_reader :image_text, :image_name
			@@image_text_randoms = "123456789abcdefghjmnpqstwxyzABCDEFGHJMNPQRSTWXYZ"

			def initialize(length = 4, color = 'white', width = 75, height = 20)
				@image_wigth, @image_height, @char_length= 75, 20, length
				@image = Magick::ImageList.new
				@image.new_image(@image_wigth, @image_height, Magick::HatchFill.new(color, color))
				@image_draw = Magick::Draw.new
			end

			protected
			def add_points(color = 'white')
				@image_draw.fill(color)
				100.times do
					@image_draw.point(rand(@image_wigth), rand(@image_height))
				end
			end

			protected
			def random_chars
				length, @image_text = @@image_text_randoms.length - 1, ''
				@char_length.times { @image_text << @@image_text_randoms[rand(length)]}
			end

			public
			def picture(pic_name = '', path = '')
				@image_name = pic_name.to_s + Time.now.to_i.to_s + ".png"
				picture_path = path + @image_name
				
				self.add_points('black')
				self.add_points('yellow')
				self.add_points
				self.random_chars
				
				@image_draw.pointsize = 18 
				@image_draw.font = "#{Ash::Disposition::MAIN_DIR_ASSETS_FONTS}DejaVuSansCondensed.ttf"
				#@image_draw.stroke_width(2)
				@image_draw.stroke = 'chocolate'
				@image_draw.font_style(Magick::ItalicStyle)
				@image_draw.font_weight(Magick::LighterWeight)
				@image_draw.gravity=Magick::SouthEastGravity
				x = 8
				@image_text.reverse.each_char do |key, value|
					@image_draw.rotate(rand(2))
					@image_draw.text(x, 0, key)
					x += 15
				end
				@image_draw.draw(@image)
				@image.border!(1, 1, 'black')
				@image.write(picture_path)
			end

		end
	end
end
