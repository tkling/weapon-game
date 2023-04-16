class Options < GameState
  def bind_keys
    bind Keys::Space, ->{ proceed_to MainMenu }
  end

  def draw
    window.huge_font_draw(10, 10, 0, 'O P T I O N S')

    message = 'Nothing here yet :[ Press [space] to return to main menu.'
    window.normal_font_draw(window.width/2-200, window.height/2, 0, message)
  end
end
