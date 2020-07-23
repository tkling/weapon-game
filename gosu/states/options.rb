class Options < GameState
  def key_pressed(id)
    set_next_and_ready(MainMenu) if id == Keys::Space
  end

  def draw
    window.huge_font_draw(10, 10, 0, Color::YELLOW, 'O P T I O N S')

    message = 'Nothing here yet :[ Press [space] to return to main menu.'
    window.normal_font_draw(window.width/2-200, window.height/2, 0, Color::YELLOW, message)
  end
end
