class CaravanMenu < GameState
  def draw
    x_start = 25
    banner = 'C A R A V A N_M E N U'
    window.huge_font_draw(x_start, 15, 0, Color::YELLOW, banner)

    map_str = "Map: #{ map.name }"
    dun_str = "Dungeon: #{ dungeon.name }"
    enc_str = "Encounter: #{ dungeon.encounter_index+1 }/#{ dungeon.encounters.size }"
    window.large_font_draw(x_start, 200, 30, Color::YELLOW, map_str, dun_str, enc_str)

    # if we're on a boss then show some boss special stuff here

    start_battle = '[space] - Battle'
    status = 'q - Status'
    inventory = 'w - Inventory'
    config = 'e - Config'
    save = 'r - Save'
    exit = 'x - Exit'
    window.large_font_draw(window.width-200, 150, 40, Color::YELLOW, start_battle, status, inventory, config, save, exit)
  end

  def bind_keys
    bind Keys::Space, ->{ proceed_to Battling }
    bind Keys::Enter, ->{ proceed_to Battling }
    bind Keys::Q,     ->{ proceed_to Status }
    bind Keys::W,     ->{ proceed_to Inventory }
    bind Keys::E,     ->{ proceed_to PartyConfig }
    bind Keys::R,     ->{ proceed_to Save }
    bind Keys::X,     ->{ window.close }
  end
end
