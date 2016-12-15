class Battling < GameState
  # TODO
  # 1. disable non-useable keys during battle
  # 2. only show enemies as targets when their HP > 0
  # 3. add battle timers (per-decision, global for battle also?)
  # 4. think about loot/xp (model xp growth also somehow?)

  INTERNAL_STATES = %i(collecting_party_commands selecting_target)
  TARGET_KEYS = { Gosu::KbQ => 'q', Gosu::KbW => 'w', Gosu::KbE => 'e', Gosu::KbR => 'r' }.freeze

  def initialize(window)
    super window
    @current_partymember_idx = 0
    @commands = Hash.new
    @target_map = make_target_map
    @skill_map = make_skill_map
    @damages = []
    @internal_state = :collecting_party_commands
  end

  def make_target_map
    target_keys = [Gosu::KbQ, Gosu::KbW, Gosu::KbE, Gosu::KbR]
    mapping = Hash.new
    current_enemies.each_with_index { |enemy, idx| mapping[enemy] = target_keys[idx] }
    mapping
  end

  def make_skill_map
    mapping = Hash.new
    party.each do |partymember|
      character_skill_map = Hash.new
      partymember.skill_mappings.each { |keypress, skill| character_skill_map[keypress] = skill }
      mapping[partymember] = character_skill_map
    end
    mapping
  end

  def current_partymember
    party[@current_partymember_idx]
  end

  def update
    if @commands.count == 3
      if @commands.map { |_, skill_hash| skill_hash[:target] }.compact.size == 3
        # we have full party input, resolve damage
        @commands.each do |partymember, skill_info|
          to = skill_info[:target]
          damage = Damage.new(from: partymember, to: to, source: skill_info[:skill])
          @damages << damage
          to.damage << damage
        end

        @showing_damage_resolution = true
        @awaiting_confirmation = true
        @current_partymember_idx = 0
        @commands = {}
      end

      if current_enemies.map { |ene| ene.current_hp }.reduce(:+) <= 0
        set_next_and_ready Victory.new(@window, ['good_loot'])
      end
    end
  end

  def draw
    banner = 'B A T T L E'
    @window.huge_font_draw(25, 15, 0, Color::YELLOW, banner)

    # player list
    x_left = 25
    party_y_start = 200
    party.each do |partymember|
      line1 = "#{ partymember.name } - #{ partymember.job }"
      line2 = "HP: #{ partymember.current_hp}/#{ partymember.max_hp }"
      @window.normal_font_draw(x_left, party_y_start, 20, Color::YELLOW, line1, line2)
      party_y_start += 80
    end

    # enemy list
    enemy_y_start = 200
    current_enemies.each do |enemy|
      line1 = "#{ TARGET_KEYS[@target_map[enemy]] } - #{ enemy.name } - #{ enemy.job }"
      line2 = "HP: #{ enemy.current_hp}/#{ enemy.max_hp }"
      @window.normal_font_draw(@window.width-200, enemy_y_start, 20, Color::YELLOW, line1, line2)
      enemy_y_start += 80
    end

    # skill/target select OR damage resolution
    if @showing_damage_resolution
      @window.large_font_draw(230, 175, 0, Color::YELLOW, 'Damage dealt:')
      @window.normal_font_draw(230, 225, 35, Color::YELLOW, *@damages.map(&:message))
      @window.normal_font_draw(250, @window.height-200, 0, Color::YELLOW, 'Press [space] to continue')
    else
      enter_command = if skill_for_current_command? #@commands[current_partymember][:skill]
                        "Select target for #{ current_partymember.name }'s #{ @commands[current_partymember][:skill].name }"
                      else
                        "Select skill for #{ current_partymember.name }"
                      end
      @window.large_font_draw(25, 120, 0, Color::YELLOW, enter_command)

      # show skill or target list
      texts = skill_for_current_command? ? target_mapping_strings : current_hero_skill_mappings
      @window.huge_font_draw(230, 175, 75, Color::YELLOW, *texts)
    end

    # show skill choices and target
    skill_choices = "commands: #{ @commands.map { |char, s_info| { char.name => s_info[:skill]&.name } } }"
    @window.small_font_draw(@window.width-500, @window.height-20, 0, Color::YELLOW, skill_choices)
  end

  def skill_for_current_command?
    !!@commands.dig(current_partymember, :skill)
  end

  def target_mapping_strings
    @target_map.map do |enemy, keypress|
      "#{ TARGET_KEYS[keypress] } - #{ enemy.name }"
    end
  end

  def current_hero_skill_mappings
    current_partymember.skill_mappings.map do |keypress, skill|
      "#{ TARGET_KEYS[keypress] } - #{ skill.name }"
    end
  end

  def key_pressed(id)
    if @commands.size <= 3 && !@awaiting_confirmation
      case id
      when Gosu::KbQ, Gosu::KbW, Gosu::KbE, Gosu::KbR
        if @commands[current_partymember] == nil
          @commands[current_partymember] = { skill: @skill_map[current_partymember][id] }
        else
          @commands[current_partymember][:target] = @target_map.key id
          @current_partymember_idx += 1
        end
      end
    end

    if @awaiting_confirmation
      if id == Gosu::KbSpace
        @showing_damage_resolution = false if @showing_damage_resolution
        @awaiting_confirmation = false
      end
    end
  end
end
