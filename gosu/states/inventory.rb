class Inventory < GameState
  def key_pressed(id)
    set_next_and_ready(CaravanMenu) if id == Keys::Space
  end

  def draw
    message = 'Come back later~'
    window.huge_font_draw(window.width/3, window.height/3, 0, Color::YELLOW, message)

    press_space = 'Press [space] to return to caravan menu.'
    window.large_font_draw(window.width/3-200, window.height/3+100, 0, Color::YELLOW, press_space)
  end
end
