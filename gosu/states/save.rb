class Save < GameState
  include SaveMethods

  def bind_keys
    bind Keys::Q,    ->{ save(save_name) }
    bind Keys::Space, ->{ proceed_to(CaravanMenu) if file_saved? }
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

    window.large_font_draw(window.width/2-40, window.height-300, 30, Color::YELLOW,
      'Time played:',
      formatted_time_played
    )
  end

  def save_name
    window.globals.save_data.filename
  end
end
