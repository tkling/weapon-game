class XpRewards < GameState
  def initialize(window, xp_reward)
    super window
    @xp_reward = xp_reward
    @progression_infos = window.globals.party.map do |p|
      p.xp_progression_info(@xp_reward).merge(name: p.name)
    end
  end

  def key_pressed(id)
    set_next_and_ready(CaravanMenu) if id == Keys::Space
  end

  def draw
    window.huge_font_draw(  10, 10,  0, Color::YELLOW, 'X P')
    window.large_font_draw(20, 100, 0, Color::YELLOW, "XP gained: #{@xp_reward}")

    @partymember_progression_strings ||= @progression_infos.map do |info|
      l1, l2 = info[:starting_level], info[:level_after_reward]
      level_string = l1 < l2 ? "#{l1} -> #{l2}" : l1
      xp_string = "#{info[:xp_after_reward]}/#{Experience::LevelMap[info[:level_after_reward] + 1]}"
      "#{info[:name]}: Level #{level_string}, XP: #{xp_string}"
    end

    window.normal_font_draw(window.width/2-100, window.height/3, 40, Color::YELLOW, *@partymember_progression_strings)
    window.normal_font_draw(window.width/2-100, window.height-150, 0, Color::YELLOW, 'Press [space] to continue.')
  end
end
