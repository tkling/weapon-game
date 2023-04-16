class XpRewards < GameState
  def initialize(window, xp_tracker)
    super window
    @xp_tracker = xp_tracker
    @progression_infos = window.globals.party.map do |pm|
      xp_tracker.xp_progression_info_for(pm).merge(name: pm.name)
    end
  end

  def bind_keys
    bind Keys::Space, ->{
      @xp_tracker.award!
      next_screen = map.complete? ? MapCompleted : CaravanMenu
      proceed_to(next_screen)
    }
  end

  def draw
    window.huge_font_draw( 10, 10,  0, 'X P')
    window.large_font_draw(20, 100, 0, 'XP gained: CHANGE THIS TO INDIVIDUAL CHARACTERS')

    @partymember_progression_strings ||= @progression_infos.map do |info|
      l1, l2 = info[:starting_level], info[:level_after_reward]
      level_string = l1 < l2 ? "#{l1} -> #{l2}" : l1
      xp_string = "#{info[:xp_after_reward]}/#{Experience::LevelMap[info[:level_after_reward] + 1]}"
      "#{info[:name]}: Level #{level_string}, XP: #{xp_string}"
    end

    window.normal_font_draw(window.width/2-100, window.height/3, 40, *@partymember_progression_strings)
    window.normal_font_draw(window.width/2-100, window.height-150, 0, 'Press [space] to continue.')
  end
end
