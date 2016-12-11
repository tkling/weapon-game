class StartJourney < GameState
  def initialize(window)
    super window
     if @window.globals.party.size < 3
       binding.pry # something is wrong, we should have a party
     end
  end

  def key_pressed(id)
    if id == Gosu::KbQ
      set_next_and_ready DungeonStart
    end
  end

  def draw
    # draw party info
    @x_padding ||= 40
    @x_starts ||= [0, @window.width/3, @window.width * 0.66667].map { |i| i + @x_padding }
    @x_starts.each_with_index do |x, idx|
      partymember = @window.globals.party[idx]
      weapon_name = "Weapon: #{ partymember.weapon.name }"
      armor_name = "Armor: #{ partymember.armor.name }"
      total_atk = "ATK: #{ partymember.total_atk }"
      max_hp = "Max HP: #{ partymember.max_hp }"
      curr_hp = "Current HP: #{ partymember.current_hp }"

      @window.large_font_draw(x, 25, 0, Color::YELLOW, partymember.name)
      @window.small_font_draw(x, 65, 30, Color::YELLOW, weapon_name, armor_name, total_atk, max_hp, curr_hp)
    end

    # show current map + dungeon
    @map_name ||= "Map: #{ map.name }"
    @current_dungeon ||= "Current dungeon: #{ dungeon.name }"
    @encounters_completed ||= "Encounters completed dungeon: #{ dungeon.encounter_index }/#{ dungeon.encounter_count}"

    @window.large_font_draw(@x_padding, @window.height - 300, 0, Color::YELLOW, @map_name)
    @window.normal_font_draw(@x_padding, @window.height - 250, 20, Color::YELLOW, @current_dungeon, @encounters_completed)

    # show confirmation
    @continue_msg ||= 'press q to continue with this party'
    @window.large_font_draw(170, @window.height - 130, 0, Color::YELLOW, @continue_msg)
  end
end
