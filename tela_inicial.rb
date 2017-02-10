require 'gosu'
require_relative 'ariel'
require_relative 'estrela'
require_relative 'ursula'
require_relative 'poderzinho'
require_relative 'concha'
require_relative 'pedra'

	class TelaInicial < Gosu::Window
		ESTRELA = 0.01
		URSULA = 0.01
		CONCHA = 0.02
		PEDRA = 0.01

		def initialize
			super 640, 480
			self.caption = "The Little Mermaid"

			#@flor == status
			@flor = "inicio"
			@background_image = Gosu::Image.new("image/tela_inicial_2.png", :tileable => true)
			@background_song = Gosu::Song.new("musica_tema.wav")
			@background_song.play(true)
			@map_image = Gosu::Image.new("image/mar_2.png")
			@map_image2 = Gosu::Image.new("image/mar_3.png")
			@ariel = Ariel.new
			@background_image2 = Gosu::Image.new("image/finaltela.png")
			@estrela = []
			@font = Gosu::Font.new(25)
			@placar = 0
			@tempo = 0.0
			@ursula = []
			@poderzinho = []
			@tempoanterior = 0.0
			@concha = []
			@pedra = []
		end

		def update
			if @flor == "inicio" then
				update_inicio
			elsif @flor == "jogar" then
				update_jogar
			elsif @flor == "final" then
				update_final
			elsif @flor == "fase" then
				update_fase
			end
		end

		def update_inicio
			if Gosu::button_down? Gosu::KbReturn or Gosu::button_down? Gosu::KbEnter then
				@flor = "jogar"
			end
		end

		def update_jogar
			if Gosu::button_down? Gosu::KbEscape then
				close
			end
			if Gosu::button_down? Gosu::KbRight then
				@ariel.move(1,0)
			end
			if Gosu::button_down? Gosu::KbLeft then
				@ariel.move(-1,0)
			end
			if Gosu::button_down? Gosu::KbUp then
				@ariel.move(0,-1)
			end
			if Gosu::button_down? Gosu::KbDown then
				@ariel.move(0,1)
			end
			if rand < ESTRELA then
				@estrela.push Estrela.new(self)
			end
			@estrela.dup.each do |estrela|
				if (Gosu::distance(@ariel.x,@ariel.y,estrela.x,estrela.y)) < 30 then
					@estrela.delete estrela
					@placar += 10
				end
			end
			if rand < CONCHA then
				@concha.push Concha.new(self)
			end
			@concha.dup.each do |concha|
				if (Gosu::distance(@ariel.x,@ariel.y,concha.x,concha.y)) < 30 then
					@concha.delete concha
					@placar += 5
				end
			end
			if rand < PEDRA then
				@pedra.push Pedra.new(self)
			end
			@pedra.dup.each do |pedra|
				if (Gosu::distance(@ariel.x,@ariel.y,pedra.x,pedra.y)) < 30 then
					@pedra.delete pedra
					@placar -= 15
				end
			end
			dif = @tempo.to_i/30
			@tempo += 1.0/60.0
			if (@placar < 300 && @tempo >= 60.0) then
				@flor = "final"
			end
			if (@tempo > 70.0) then
				@flor = "fase"
			end
			if (@placar < 0) then
				@flor = "final"
			end
		end

		def update_final
			if Gosu::button_down? Gosu::KbReturn then
				initialize
			end
		end

		#Início da Segunda Fase 'Update'
		def update_fase
			if Gosu::button_down? Gosu::KbEscape then
				close
			end
			if Gosu::button_down? Gosu::KbRight then
				@ariel.move(1,0)
			end
			if Gosu::button_down? Gosu::KbLeft then
				@ariel.move(-1,0)
			end
			if Gosu::button_down? Gosu::KbUp then
				@ariel.move(0,-1)
			end
			if Gosu::button_down? Gosu::KbDown then
				@ariel.move(0,1)
			end
			if rand < URSULA then
				@ursula.push Ursula.new(self)
			end
			@ursula.each do |ursula|
				ursula.move
			end
			@ursula.dup.each do |ursula|
				if (Gosu::distance(@ariel.x,@ariel.y,ursula.x,ursula.y)) < 30 then
					@flor = "final"
				end
			end
			if Gosu::button_down? Gosu::KbSpace then
				if(@tempoanterior + 1 < @tempo)
					@poderzinho.push Poderzinho.new(self, @ariel.x, @ariel.y)
					@tempoanterior = @tempo
				end
			end
			@poderzinho.each do |poderzinho|
				poderzinho.move
			end
			dif= @tempo.to_i/30
			@tempo += 1.0/60.0
			@ursula.dup.each do |ursula|
				@poderzinho.dup.each do |poderzinho|
					distance = Gosu::distance(ursula.x,ursula.y,poderzinho.x,poderzinho.y)
					if distance < 20 then 
						@ursula.delete ursula
						@poderzinho.delete poderzinho
						@placar += 10
					end
				end
			end
			#if (@placar < 700 ) then
				#@flor = "final"
			#end
		end
		#Fim da Segunda Fase 'Update'

		def draw
			if @flor == "inicio" then
				draw_inicio()
			elsif @flor == "jogar" then
				draw_jogar()
			elsif @flor == "final" then
				draw_final()
			elsif @flor == "fase"
				draw_fase()
			end
		end

		def draw_inicio
			@background_image.draw(0,0,0)
		end

		def draw_jogar
			@map_image.draw(0,0,0)
			@ariel.draw
			@estrela.each do |estrela|
				estrela.draw
			end
			@concha.each do |concha|
				concha.draw
			end
			@pedra.each do |pedra|
				pedra.draw
			end
			@font.draw("Placar: #{@placar}",520,30,1,1,1,0xffff00ff)
			@font.draw("Tempo: #{@tempo}",520,10,1,1,1,0xffff00ff)
		end

		def draw_final
			@background_image2.draw(0,0,0)
			@font.draw("#{@placar}",300,210,1,1,1,0xffff00ff)
			@font.draw("#{@tempo.round(1)}",300,270,1,1,1,0xffff00ff)
		end

		#Início da Segunda Fase 'Draw'
		def draw_fase
			@map_image2.draw(0,0,0)
			@ariel.draw
			@ursula.each do |ursula|
				ursula.draw
			end
			@poderzinho.each do |poderzinho|
				poderzinho.draw
			end
			@font.draw("Placar: #{@placar}",520,30,1,1,1,0xffff00ff)
			@font.draw("Tempo: #{@tempo - 70}",520,10,1,1,1,0xffff00ff)
		end
		#Fim da Segunda Fase 'Draw'
	end

window = TelaInicial.new
window.show
