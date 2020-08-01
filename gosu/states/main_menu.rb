class MainMenu < GameState
  def bind_keys
    bind Keys::Q,               ->{ proceed_to NewGame }
    bind Keys::W,               ->{ proceed_to Continue }
    bind Keys::E,               ->{ proceed_to Options }
    bind Keys::Escape, Keys::D, ->{ window.close }
  end

  def draw
    header = 'WEAPON GAME MAIN MENU'
    window.huge_font_draw(45, 20, 0, Color::YELLOW, header)

    new_game = 'q - new game'
    continue = 'w - continue'
    options = 'e - options'
    close = 'd - exit'
    window.large_font_draw(320, 200, 40, Color::YELLOW, new_game, continue, options, close)
  end
end
