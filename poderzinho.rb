require 'gosu'

class Poderzinho

	attr_reader :x, :y
	def initialize(window,x,y)
		@x = x + 20
		@y = y
		@image = Gosu::Image.new("image/power_2.png")
	end

	def draw
		@image.draw(@x,@y,0)
	end

	def move
		@x += 4
	end

end
