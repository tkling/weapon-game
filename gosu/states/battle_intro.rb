# frozen_string_literal: true
class BattleIntro < GameState
  TITLE_PHRASES = [
    'Steel thyself!',
    "Hope you're ready...",
    "Aren't these monsters annoying?",
    'Get ready to battle!',
    "Jeez they just don't stop :o"
  ].freeze

  def initialize(window)
    super
    @time_opened = Time.now
    @random_phrase = TITLE_PHRASES.sample
    @dungeon_info_display = "#{dungeon.name} #{dungeon.encounter_index+1}/#{dungeon.encounters.size}"
  end

  def update
    time_diff = Time.now - @time_opened
    proceed_to(Battling) if time_diff >= 4

    @display_time = (time_diff.truncate - 3).abs
    @display_time = 'GO!' if @display_time < 1.0
  end

  def draw
    window.huge_font_draw(10, 10, 0, @dungeon_info_display)
    window.large_font_draw(40, 85, 0, @random_phrase)
    window.huge_font_draw(window.width/2, window.height/2, 0, @display_time)
  end
end
