# frozen_string_literal: true

class Battling < GameState
  TARGET_KEYS = { Keys::Q => 'q', Keys::W => 'w', Keys::E => 'e', Keys::R => 'r' }.freeze

  def initialize(window)
    super window
    @current_partymember_idx = 0
    @commands = Hash.new
    @target_map = make_target_map
    @skill_map = make_skill_map
    @damages = []
    @battle = Battle.new(party, enemies)
  end

  def make_target_map
    enemies.each_with_index.with_object(Hash.new) do |(enemy, idx), mapping|
      mapping[enemy] = TARGET_KEYS.keys[idx]
    end
  end

  def make_skill_map
    party.each_with_object({}) do |partymember, mapping|
      mapping[partymember] = partymember.skill_mappings.each_with_object({}) do |(keypress, skill), char_skill_map|
        char_skill_map[keypress] = skill
      end
    end
  end

  def update
    @battle.update

    if @battle.phase == :victory
      window.globals.inventory += @battle.loot
      proceed_to Victory.new(window, @battle.loot)
    end

    if @battle.phase == :round_end
      @showing_damage_resolution = true
      @awaiting_confirmation = true
    end
  end

  def draw
    window.huge_font_draw(25, 15, 0, Color::YELLOW, 'B A T T L E')

    # decision timer
    window.normal_font_draw(window.width-420, 30, 20, Color::YELLOW, *decision_timer_messages)

    # player list
    x_left = 25
    party_y_start = 200
    party.each do |partymember|
      line1 = "#{ partymember.name } - #{ partymember.job }"
      line2 = "HP: #{ partymember.current_hp }/#{ partymember.max_hp }"
      window.normal_font_draw(x_left, party_y_start, 20, Color::YELLOW, line1, line2)
      party_y_start += 80
    end

    # enemy list
    enemy_y_start = 200
    enemies.select { |ene| ene.current_hp > 0 }.each do |enemy|
      line1 = "#{ TARGET_KEYS[@target_map[enemy]] } - #{ enemy.name } - #{ enemy.job }"
      line2 = "HP: #{ enemy.current_hp}/#{ enemy.max_hp }"
      window.normal_font_draw(window.width-200, enemy_y_start, 20, Color::YELLOW, line1, line2)
      enemy_y_start += 80
    end

    # skill/target select OR damage resolution
    if @showing_damage_resolution
      window.large_font_draw(230, 175, 0, Color::YELLOW, 'Damage dealt:')
      window.normal_font_draw(230, 225, 35, Color::YELLOW, *@battle.damages.map(&:message))
      window.normal_font_draw(250, window.height-120, 0, Color::YELLOW, 'Press [space] to continue')
    elsif %i[select_partymember_skill select_partymember_target].include?(@battle.phase)
      window.large_font_draw(25, 120, 0, Color::YELLOW,
        if @battle.phase == :select_partymember_target
         "Select target for #{ @battle.current_battle_participant.name }'s #{ @battle.current_command[:skill].name }"
        else
         "Select skill for #{ @battle.current_battle_participant.name }"
        end
      )

      # show skill or target list
      texts = @battle.phase == :select_partymember_target ? target_mapping_strings : current_hero_skill_mappings
      window.huge_font_draw(230, 175, 75, Color::YELLOW, *texts)
    end

    # show skill choices and target
    skill_choices = "commands: #{ @battle.commands.map { |char, s_info| { char.name => s_info[:skill]&.name } } }"
    window.small_font_draw(window.width-500, window.height-20, 0, Color::YELLOW, skill_choices)
  end

  def target_mapping_strings
    @target_map.select { |enemy, _| enemy.current_hp > 0 }.map do |enemy, keypress|
      "#{ TARGET_KEYS[keypress] } - #{ enemy.name }"
    end
  end

  def current_hero_skill_mappings
    @battle.current_battle_participant.skill_mappings.map do |keypress, skill|
      "#{ TARGET_KEYS[keypress] } - #{ skill.name }"
    end
  end

  def decision_timer_messages
    bar_count = (@battle.decision_percentage_remaining / 4.0).ceil
    timer = "Decision Timer: |#{ '=' * bar_count }|"
    bonus = "Bonus: #{ bar_count/2.5 }"
    [timer, bonus]
  end

  def bind_keys
    bind Keys::Space, ->{ handle_end_of_round }

    [Keys::Q, Keys::W, Keys::E, Keys::R].each do |key|
      bind key, ->{ handle_battle_command(key) }
    end
  end

  def handle_battle_command(key)
    return unless [:select_partymember_skill, :select_partymember_target].include?(@battle.phase)
    @battle.start_decision

    phase_actions = {
      select_partymember_skill: ->{ @battle.assign_skill_choice(@skill_map[@battle.current_battle_participant][key]) },
      select_partymember_target: ->{ @battle.assign_skill_target(@target_map.key(key)) }
    }

    phase_actions[@battle.phase]&.call
  end

  def handle_end_of_round
    return unless @awaiting_confirmation
    @battle.reset_round_state
    @showing_damage_resolution = false if @showing_damage_resolution
    @awaiting_confirmation = false
  end
end
