class Victory < GameState
  attr_reader :loot

  def initialize(window, loot)
    super window
    @loot = loot
    advance_journey_progress
  end

  def bind_keys
    bind Keys::Space, ->{ proceed_to XpRewards.new(window, 250) }
  end

  def draw
    banner = 'V I C T O R Y'
    window.huge_font_draw(25, 15, 0, Color::YELLOW, banner)

    loot_banner = 'loot'
    loot_box_y_start = 125
    window.large_font_draw(55, loot_box_y_start, 0, Color::YELLOW, loot_banner)
    window.normal_font_draw(60, loot_box_y_start + 50, 0, Color::YELLOW, *loot)

    advancement_text = 'press [space] to continue'
    window.large_font_draw((window.width / 2) - 150, window.height - 150, 0, Color::YELLOW, advancement_text)
  end

  def advance_journey_progress
    if dungeon.complete?
      map.dungeon_index += 1 unless map.complete?
    else
      dungeon.encounter_index += 1
    end
  end

  def update
    # animate multiple xp bars one at a time? need to track animation state
  end
end
