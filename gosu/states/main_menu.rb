class MainMenu < GameState
  def key_pressed(id)
    case id
    when Keys::Escape, Keys::D
      window.close
    when Keys::Q
      set_next_and_ready NewGame
    when Keys::W
      set_next_and_ready Continue
    when Keys::E
      set_next_and_ready Options
    end
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
