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
    @x_padding ||= 60
    @x_starts ||= [0, @window.width/3, @window.width * 0.66667].map { |i| i + @x_padding }
    @x_starts.each_with_index do |x, idx|
      partymember = @window.globals.party[idx]
      weapon_name = "Weapon: #{ partymember.weapon.name }"
      armor_name = "Armor: #{ partymember.armor.name }"
      total_atk = "ATK: #{ partymember.total_atk }"
      max_hp = "Max HP: #{ partymember.max_hp }"
      curr_hp = "Current HP: #{ partymember.current_hp }"

      @window.large_font_draw(x, 15, 0, Color::YELLOW, partymember.name)
      @window.small_font_draw(x, 60, 30, Color::YELLOW, weapon_name, armor_name, total_atk, max_hp, curr_hp)
    end

    # show current dungeon
    # need to add dungeon stuff, lol!

    # show confirmation
    @continue_msg ||= 'press q to continue with this party'
    @window.large_font_draw(170, @window.height - 100, 0, Color::YELLOW, @continue_msg)
  end
end
