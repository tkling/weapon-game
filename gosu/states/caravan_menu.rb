class CaravanMenu < GameState
  def draw
    x_start = 25
    banner = 'C A R A V A N M E N U'
    @window.huge_font_draw(x_start, 15, 0, Color::YELLOW, banner)

    map_str = "Map: #{ map.name }"
    dun_str = "Dungeon: #{ dungeon.name }"
    enc_str = "Encounter: #{ dungeon.encounter_index+1 }/#{ dungeon.encounters.size }"
    @window.large_font_draw(x_start, 200, 30, Color::YELLOW, map_str, dun_str, enc_str)

    status = 'q - Status'
    inventory = 'e - Inventory'
    config = 'e - Config'
    save = 'r - Save'
    exit = 'q - Exit'
    @window.large_font_draw(@window.width-150, 80, 40, Color::YELLOW, status, inventory, config, save, exit)
  end

  def key_pressed(id)
    case id
    when Gosu::KbQ
      set_next_and_ready Status
    when Gosu::KbW
      set_next_and_ready Inventory
    when Gosu::KbE
      set_next_and_ready Config
    when Gosu::KbR
      set_next_and_ready Save
    when Gosu::KbX
      @window.close
    end
  end
end
