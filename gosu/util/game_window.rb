# frozen_string_literal: true
require 'singleton'

class GameWindow < Gosu::Window
  include Singleton

  attr_reader :start_time, :small_font, :normal_font, :large_font, :huge_font, :project_root, :globals, :state

  def update
    state.update
    advance_state
  rescue StandardError => e
    bt = e.backtrace
    binding.pry
  end

  def draw
    draw_state_info
    state.draw
  rescue StandardError => e
    bt = e.backtrace
    binding.pry
  end

  def draw_state_info
    state_info = "current state: #{ @state.class }"
    transition_info = "from #{ @last_state.class } to #{ @state.class } (last key: #{ @last_keypress })"
    small_font_draw(5, 565, 15, state_info, transition_info)
  end

  def button_down(id)
    @last_keypress = id
    @state.handle_global_keypresses id
    @state.key_pressed id
  rescue StandardError => e
    bt = e.backtrace
    binding.pry
  end

  def advance_state
    if @ready_to_advance
      @last_state = @state
      @ready_to_advance = false
      @state = state.next.class == Class ? state.next.new(self) : state.next
      @state.setup
    end
  end

  def ready_to_advance_state!
    @ready_to_advance = true
  end

  %i(small_font normal_font large_font huge_font).each do |font|
    define_method "#{ font }_draw" do |x, y, y_space, *messages, color: Color::YELLOW|
      messages.each do |msg|
        send(font).draw_text(msg, x, y, ZOrder::UI, 1.0, 1.0, color)
        y += y_space
      end
    end
  end

  private

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
    @globals.save_data = SaveData.new
  end
end
