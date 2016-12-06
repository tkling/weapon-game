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
end

class WelcomeScreen < GameState
  def update
    if Time.now - @window.start_time > 3.5
      @window.ready_to_advance_state!
    end
  end

  def draw
    message = 'THIS IS WEAPON GAME'
    @window.huge_font.draw(message, 10, 10, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
  end

  def key_pressed(id)
    if id == Gosu::KbEnter || id == Gosu::KbEscape
      @window.ready_to_advance_state!
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
      @next = NewGame
      @window.ready_to_advance_state!
    when Gosu::KbW
      @next = Continue
      @window.ready_to_advance_state!
    when Gosu::KbE
      @next = Options
      @window.ready_to_advance_state!
    end
  end

  def next
    @next
  end

  def draw
    header = 'WEAPON GAME MAIN MENU'
    @window.huge_font_draw(10, 10, 0, Color::YELLOW, header)

    new_game = 'q - new game'
    continue = 'w - continue'
    options = 'e - options'
    close = 'd - exit'
    @window.large_font_draw(10, 100, 30, Color::YELLOW, new_game, continue, options, close)
  end
end
