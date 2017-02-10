require 'gosu'

class Ursula

	attr_reader :x, :y
	def initialize(window)
		@window = window
		@x = 600 
		@y = rand(420)
		@images = Gosu::Image.load_tiles("image/ursula_2.png", 68, 70)
		@current_frame = @images[0]
	end

	def draw
		@current_frame.draw(@x,@y,0)
		@current_frame = @images[Gosu::milliseconds / 120 % @images.size]
	end

	def move
		@x -= 2
	end
end
