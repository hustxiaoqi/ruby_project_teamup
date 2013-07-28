ACCESS_ERROR ||= true

require 'test/unit'
require 'pp'
require './BaseRandomImage.rb'


class TestUnitRandomImage < Test::Unit::TestCase
	def test_picture
		#image = Ash::Utils::CRandomImage.new
		image = TestRandomImage.new
		pp image
		image.picture 'random', File.expand_path('../../assets/image/verify/')
		pp image.image_text
	end
end
class TestRandomImage < Ash::Utils::CRandomImage
	def initialize
		super
	end

	public
	def picture(pic_name = '', path)
		picture_name = pic_name.to_s + Time.now.to_i.to_s
		self.add_points('black')
		self.add_points('yellow')
		self.add_points
		self.random_chars
		@image_draw.pointsize = 18 
		@image_draw.font = File.expand_path "../../assets/fonts/DejaVuSansMono.ttf"
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
		@image.write(path + '/' + picture_name + ".png")
	end
end

