class NewGame < GameState
  include SpawningMethods
  include SaveMethods

  def bind_keys
    bind Keys::Q,                   ->{ file_saved? ? proceed_to(StartJourney) : make_new_game }
    bind Keys::E,                   ->{ proceed_to MainMenu }
    bind Keys::Escape, Keys::Space, ->{ window.close }
  end

  def make_new_game
    if savefile_paths.size >= 9
      @save_count_reached = true
      @time_detected = Time.now
      return
    end

    window.globals.party = starting_party
    window.globals.map = starting_map
    window.globals.inventory = []
    window.globals.save_data.time_played = 0
    window.globals.session_begin_time = Time.now
    save save_name
  end

  def save_name
    @save_time_string ||= Time.now.to_s.split(' ').first(2).join('_').tr(':', '-')
    "game_#{ @save_time_string }.save"
  end

  def update
    if file_saved? && !@start_journey_set
      @confirmation = 'q to start journey'
      @start_journey_set = true
    end

    if @save_count_reached
      if Time.now - @time_detected < 2
        @confirmation = 'Only 9 saves allowed, returning to main menu.'
      else
        proceed_to MainMenu
      end
    end
  end

  def draw
    @header           ||= 'N E W G A M E'
    @save_explanation ||= "Your save will be called #{ save_name }"
    @question         ||= 'Sound good to you?'
    @confirmation     ||= 'q to continue, e to cancel'
    @success          ||= 'S U C C E S S'

    window.huge_font_draw(   10,  10,  0, Color::YELLOW, @header)
    window.normal_font_draw(240, 240, 40, Color::YELLOW, @save_explanation, @question, @confirmation)

    if file_saved?
      window.huge_font_draw(420, 520,  0, Color::YELLOW, @success)
    end
  end

  def starting_party
    %i(knight rogue priest).map do |job|
      spawn_starting_hero job
    end
  end

  def starting_map
    @dungeon_counts ||= (3..9).to_a
    Map.new(name: 'Journey to the Exit', dungeons: generate_dungeons(@dungeon_counts.sample))
  end
end
