class CaravanMenu < GameState
  def bind_keys
    bind Keys::Space, Keys::Return, Keys::Enter, ->{ proceed_to Battling }
    bind Keys::Q,                                ->{ proceed_to Status }
    bind Keys::W,                                ->{ proceed_to Inventory }
    bind Keys::E,                                ->{ proceed_to PartyConfig }
    bind Keys::R,                                ->{ proceed_to Save }
    bind Keys::X,                                ->{ window.close }
  end

  def draw
    x_start = 25
    window.huge_font_draw(x_start, 15, 0, Color::YELLOW, 'C A R A V A N_M E N U')

    window.large_font_draw(x_start, 200, 30, Color::YELLOW,
      "Map: #{ map.name }",
      "Dungeon: #{ dungeon.name }",
      "Encounter: #{ dungeon.encounter_index+1 }/#{ dungeon.encounters.size }"
    )

    window.large_font_draw(x_start, window.height-200, 30, Color::YELLOW,
      'Time played:',
      formatted_time_played
    )

    # if we're on a boss then show some boss special stuff here
    window.large_font_draw(window.width-200, 150, 40, Color::YELLOW,
      '[space] - Battle',
      'q - Status',
      'w - Inventory',
      'e - Config',
      'r - Save',
      'x - Exit'
    )
  end
end
