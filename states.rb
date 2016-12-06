# a state has: a name, non-default controls, draw method
require './constants'

class GameState
  def initialize(window)
    @window = window
  end

  def update; end
  def draw; end
  def key_pressed(id); end
  def next; end

  def notify_ready
    @window.ready_to_advance_state!
  end
end

class WelcomeScreen < GameState
  def initialize(window)
    super window
    @vertical_range_array = (20..510).to_a
    @message_y = @vertical_range_array.sample
    @y_set = Time.now
    @message = 'THIS IS WEAPON GAME'
  end

  def update
    if Time.now - @window.start_time > 3.5
      notify_ready
    end
  end

  def draw
    if Time.now - @y_set > 0.25
      @message_y = @vertical_range_array.sample
      @y_set = Time.now
    end

    @window.huge_font_draw(182, @message_y, 0, Color::YELLOW, @message)
  end

  def key_pressed(id)
    if id == Gosu::KbEnter || id == Gosu::KbEscape || id == Gosu::KbSpace
      notify_ready
    end
  end

  def next
    MainMenu
  end
end

class MainMenu < GameState
  def key_pressed(id)
    case id
    when Gosu::KbEscape, Gosu::KbD
      @window.close
    when Gosu::KbQ
      notify_ready; @next = NewGame
    when Gosu::KbW
      notify_ready; @next = Continue
    when Gosu::KbE
      notify_ready; @next = Options
    end
  end

  def next
    @next
  end

  def draw
    header = 'WEAPON GAME MAIN MENU'
    @window.huge_font_draw(45, 20, 0, Color::YELLOW, header)

    new_game = 'q - new game'
    continue = 'w - continue'
    options = 'e - options'
    close = 'd - exit'
    @window.large_font_draw(320, 200, 40, Color::YELLOW, new_game, continue, options, close)
  end
end
