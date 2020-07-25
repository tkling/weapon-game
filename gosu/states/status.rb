class Status < GameState
  def key_pressed(id)
    set_next_and_ready(CaravanMenu) if id == Keys::Space
  end

  def draw
    window.huge_font_draw(10, 10, 0, Color::YELLOW, 'S T A T U S')

    message = 'Nothing here yet :[ Press [space] to return to the caravan menu.'
    window.normal_font_draw(window.width/2-210, window.height/2, 0, Color::YELLOW, message)
  end
end
