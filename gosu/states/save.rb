class Save < GameState
  def initialize(window)
    super window
    @file_saved = false
    @spacebar_press_count = 0
    @save_name = window.globals.save_data.filename
  end

  def key_pressed(id)
    perform_save if id == Keys::Q

    if id == Keys::Space
      @spacebar_press_count += 1
      set_next_and_ready(CaravanMenu) if ready_to_return?
    end
  end

  def draw
    @banner ||= 'S A V E'
    window.huge_font_draw(10, 10, 0, Color::YELLOW, @banner)

    @message = if !@file_saved
     "Press q to overwrite your save (#{@save_name})"
    elsif @spacebar_press_count == 0
     "Save successful, press [space] to return to the Caravan screen."
    end

    window.normal_font_draw(window.width/2-240, 240, 0, Color::YELLOW, @message)
  end

  def ready_to_return?
    @file_saved && @spacebar_press_count == 1
  end

  def perform_save
    save_dir = File.join(window.project_root, 'saves')
    save_path = File.join(save_dir, @save_name)

    File.write(save_path, save_json)
    window.globals.save_data.updated_on = Time.now

    @file_saved = true
  end

  def save_json
    JSON.pretty_generate({
                             players: window.globals.party.map(&:to_h),
                             map: window.globals.map.to_h,
                             time_played: 10,
                         })
  end
end
