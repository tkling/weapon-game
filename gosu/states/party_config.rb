class PartyConfig < GameState
  INFO_PANELS = %i[overview weapon skills]

  def initialize(window)
    super window
    @character_index = @panel_index = 0
  end

  def bind_keys
    bind Keys::E,     ->{ show_next_panel }
    bind Keys::H,     ->{ change_selected_character(:left) }
    bind Keys::L,     ->{ change_selected_character(:right) }
    bind Keys::Space, ->{ proceed_to CaravanMenu }
  end

  def show_next_panel
    @panel_index += 1
    @panel_index = 0 if @panel_index >= INFO_PANELS.size
  end

  def change_selected_character(direction)
    @panel_index = 0
    @character_index += { left: -1, right: 1 }[direction]
    @character_index = wrapping_character_index(@character_index)
  end

  def wrapping_character_index(index)
    return 0 if index >= party.size
    return party.size - 1 if index.negative?
    index
  end

  def draw
    window.huge_font_draw(10, 10, 0, Color::YELLOW, 'P A R T Y')

    @panel_x_start ||= 25
    @panel_y_start ||= 150
    @top_bar_y     ||= 90

    previous_char_name = party[wrapping_character_index(@character_index-1)].name
    window.large_font_draw(10, @top_bar_y, 0, Color::YELLOW, "[H] #{previous_char_name}")

    current_char_name = party[@character_index].name
    window.huge_font_draw(window.width/2-100, @top_bar_y-10, 0, Color::YELLOW, current_char_name)

    next_char_name = party[wrapping_character_index(@character_index+1)].name
    window.large_font_draw(window.width-200, @top_bar_y, 0, Color::YELLOW, "[L] #{next_char_name}")

    window.normal_font_draw(window.width/2-100, window.height-140, 30, Color::YELLOW,
      '[h/l] previous/next character', '[e] next info panel', '[space] return to caravan menu')

    @panel_bindings ||= {
      overview: ->{ draw_overview_panel },
      weapon:   ->{ draw_weapon_panel },
      skills:   ->{ draw_skills_panel }
    }

    @panel_bindings[INFO_PANELS[@panel_index]].call
  end

  def draw_overview_panel
    window.large_font_draw(@panel_x_start, @panel_y_start, 0, Color::YELLOW, 'overview')
  end

  def draw_weapon_panel
    window.large_font_draw(@panel_x_start, @panel_y_start, 0, Color::YELLOW, 'weapon')
  end

  def draw_skills_panel
    window.large_font_draw(@panel_x_start, @panel_y_start, 0, Color::YELLOW, 'skills')
  end
end
