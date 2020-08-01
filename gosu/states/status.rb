class Status < GameState
  def bind_keys
    bind Keys::Space, ->{ proceed_to CaravanMenu }
  end

  def draw
    window.huge_font_draw(10, 10, 0, Color::YELLOW, 'S T A T U S')

    message = 'Nothing here yet :[ Press [space] to return to the caravan menu.'
    window.normal_font_draw(window.width/2-210, window.height/2, 0, Color::YELLOW, message)
  end
end
