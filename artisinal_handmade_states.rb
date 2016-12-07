$:.unshift File.dirname(__FILE__)

require 'gosu'
require 'states'

Globals = Struct.new(:party)

class GameWindow < Gosu::Window
  attr_reader :start_time, :small_font, :normal_font, :large_font, :huge_font, :project_root, :globals

  def initialize
    set_instance_vars
    super 800, 600
    self.caption = 'Xtreme Weapon Grindfest'
  end

  def set_instance_vars
    @state = WelcomeScreen.new self
    @start_time = Time.now
    @ready_to_advance = false
    @huge_font = Gosu::Font.new(60)
    @large_font = Gosu::Font.new(30)
    @normal_font = Gosu::Font.new(20)
    @small_font = Gosu::Font.new(15)
    @project_root = Dir.pwd
    @globals = Globals.new
  end

  def update
    advance_state
    @state.update
  rescue Exception, StandardError => err
    require 'pry'; binding.pry
  end

  def draw
    draw_state_info
    @state.draw
  rescue Exception, StandardError => err
    require 'pry'; binding.pry
  end

  def draw_state_info
    state_info = "current state: #{ @state.class }"
    transition_info = "from #{ @last_state.class } to #{ @state.class } (last key: #{ @last_keypress })"
    small_font_draw(5, 565, 15, Color::YELLOW, state_info, transition_info)
  end

  def button_down(id)
    @last_keypress = id
    close if id == Gosu::KbEscape
    @state.key_pressed id
  end

  def advance_state
    if @ready_to_advance
      @last_state = @state
      @ready_to_advance = false
      @state = @state.next.new self
    end
  end

  def ready_to_advance_state!
    @ready_to_advance = true
  end

  %i(small_font normal_font large_font huge_font).each do |font|
    define_method "#{ font }_draw" do |x, y_start, padding, color, *messages|
      messages.each do |msg|
        send(font).draw(msg, x, y_start, ZOrder::UI, 1.0, 1.0, color)
        y_start += padding
      end
    end
  end
end

game = GameWindow.new
game.show
