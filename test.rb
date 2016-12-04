require 'gosu'

module ZOrder
  UI = 1
end

module Color
  YELLOW = 0xff_ffff00
end

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = 'Future Weapon Game Xtreme'
    self.text_input = Gosu::TextInput.new
    @font = Gosu::Font.new(20)
  end

  def update
  end

  def draw
    @font.draw("Score: #{ 10 }", 10, 10, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
  end
end

window = GameWindow.new
window.show
