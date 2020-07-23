class PartyConfig < GameState
  def key_pressed(id)
    set_next_and_ready(CaravanMenu) if id == Keys::Space
  end

  def draw
    window.huge_font_draw(10, 10, 0, Color::YELLOW, 'P A R T Y')
    window.normal_font_draw(window.width/2-200, window.height/2, 0, Color::YELLOW,
                           'Press [space] to return to the Caravan screen, nothing here yet.')
  end
end