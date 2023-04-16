class StartJourney < GameState
  def bind_keys
    bind Controls::Confirm, ->{ proceed_to CaravanMenu }
    bind Controls::Cancel,  ->{ proceed_to MainMenu }
  end

  def draw
    # party info
    @x_padding ||= 35
    @x_starts ||= [0, window.width/3-20, window.width*0.6667-10].map { |i| i + @x_padding }
    @x_starts.each_with_index do |x, idx|
      partymember = window.globals.party[idx]
      weapon_name = "Weapon: #{partymember.weapon.name}"
      armor_name = "Armor: #{partymember.armor.name}"
      stats = "str: #{partymember.str}, dex: #{partymember.dex}, int: #{partymember.int}"
      hp = "HP: #{partymember.current_hp}/#{partymember.max_hp}"

      window.large_font_draw(x, 25, 0, partymember.name)
      window.small_font_draw(x, 65, 25, weapon_name, armor_name, stats, hp)
    end

    # current map + dungeon
    @map_name ||= "Map: #{map.name}"
    @total_dungeons ||= "Dungeon count: #{map.dungeons.size}"
    @current_dungeon ||= "Current dungeon: #{dungeon.name}"
    @encounters_completed ||= "Dungeon encounters completed: #{dungeon.encounter_index}/#{dungeon.encounters.size}"
    @dungeon_names ||= map.dungeons.map(&:name)
    @middle_y_start ||= window.height - 350

    window.large_font_draw(@x_padding, @middle_y_start, 0, @map_name)
    window.normal_font_draw(@x_padding, @middle_y_start + 40, 25,
                             @total_dungeons, @current_dungeon, @encounters_completed)

    # dungeons
    @from_left ||= window.width - @x_padding - 360
    @dungeon_list_y ||= @middle_y_start + 40

    @dungeon_list_1, @dungeon_list_2 =
      if map.dungeons.size == 1
        [map.dungeons.first.name, []]
      elsif map.dungeons.size % 2 == 0
        [map.dungeons[0..map.dungeons.size/2-1].map(&:name),
         map.dungeons[map.dungeons.size/2..map.dungeons.size-1].map(&:name)]
      else
        [map.dungeons[0..map.dungeons.size/2].map(&:name),
         map.dungeons[map.dungeons.size/2+1..map.dungeons.size-1].map(&:name)]
      end

    window.large_font_draw(@from_left, @middle_y_start, 0 , 'Dungeons:')
    window.normal_font_draw(@from_left, @dungeon_list_y, 25, *@dungeon_list_1)
    window.normal_font_draw(@from_left + 185, @dungeon_list_y, 25, *@dungeon_list_2)

    # show confirmation
    @continue_msg ||= 'e to continue with this party'
    @main_menu_msg ||= 'u to return to main menu'
    window.large_font_draw(window.width/2-175, window.height - 145, 35, @continue_msg, @main_menu_msg)
  end
end
