require 'gosu'

class Ariel

	attr_reader :x, :y
	def initialize()
		@x = 47
		@y = 40
		@images = Gosu::Image.load_tiles("image/sereia1.png", 37, 57)
		@current_frame = @images[0]
		@images2 = Gosu::Image.load_tiles("image/sereia2.png", 37, 57)
	end

	def draw
		@current_frame.draw(@x,@y,0)
		if Gosu::button_down? Gosu::KbRight then
			@current_frame = @images[Gosu::milliseconds / 120 % @images.size]
		elsif Gosu::button_down? Gosu::KbLeft then
			@current_frame = @images2[Gosu::milliseconds / 120 % @images2.size]
		end

	end

	def move(x,y)
		if(@x <= 600 && x > 0) then
			@x += x
		elsif(@x >= 5 && x < 0) then
			@x += x
		end
		if(@y <= 420 && y > 0) then
			@y += y
		elsif(@y >= 5 && y < 0) then
			@y += y
		end
	end


end
