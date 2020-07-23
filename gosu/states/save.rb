class Save < GameState
  include SaveMethods

  def key_pressed(id)
    save(save_name) if id == Keys::Q

    if id == Keys::Space
      set_next_and_ready(CaravanMenu) if file_saved?
    end
  end

  def draw
    @banner ||= 'S A V E'
    window.huge_font_draw(10, 10, 0, Color::YELLOW, @banner)

    @message = if file_saved?
                 "Save successful, press [space] to return to the Caravan screen."
               else
                 "Press q to overwrite your save (#{save_name})"
               end

    window.normal_font_draw(window.width/2-240, 240, 0, Color::YELLOW, @message)
  end

  def save_name
    window.globals.save_data.filename
  end
end
