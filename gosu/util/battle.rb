class Battle
  attr_reader :battle_order, :party, :enemies, :commands, :damages, :phase, :loot

  PHASES = %i[
    select_partymember_skill
    select_partymember_target
    assign_enemy_action,
    round_end
    victory
    defeat
  ].freeze

  def initialize(party, enemies)
    @party, @enemies = party, enemies
    reset_round_state
  end

  def reset_round_state
    @commands, @damages, @decision_start = {}, [], nil
    @battle_order = determine_battle_order
    @battle_order_index = 0
    @phase = determine_phase
  end

  def determine_battle_order
    # in the future this should be sorted by dex/priority
    party #+ enemies
  end

  def current_battle_participant
    @battle_order[@battle_order_index]
  end

  def current_command
    commands[current_battle_participant]
  end

  def assign_skill_choice(skill)
    return @incorrect_skill_chosen = true if skill.nil?
    raise 'not in :select_partymember_skill phase!' unless phase == :select_partymember_skill
    commands[current_battle_participant] = { skill: skill }
    @incorrect_skill_chosen = false
    @phase = :select_partymember_target
  end

  def assign_skill_target(target)
    return @incorrect_target_chosen = true unless target && target.current_hp > 0
    raise 'not in :select_partymember_target phase!' unless phase == :select_partymember_target
    commands[current_battle_participant][:target] = target
    commands[current_battle_participant][:time_taken] = Time.now - @decision_start
    @incorrect_target_chosen = false
    @battle_order_index += 1
  end

  def start_decision
    @decision_start = Time.now
  end

  def determine_phase
    if current_battle_participant.nil? && commands.count == battle_order.count && commands.all? { |char, com| char && com[:skill] && com[:target] }
      :round_end
    elsif enemies.none? { |ene| ene.current_hp > 0 }
      :victory
    elsif party.none? { |pm| pm.current_hp > 0 }
      :defeat
    elsif party.include?(current_battle_participant) && current_command&.dig(:skill).nil?
      :select_partymember_skill
    elsif party.include?(current_battle_participant) && current_command&.dig(:target).nil?
      :select_partymember_target
    elsif enemies.include?(current_battle_participant)
      :assign_enemy_action
    else
      raise 'unable to determine battle phase'
    end
  end

  def assign_damages
    return if @commands.any? { |_, skill_hash| skill_hash[:target].nil? }
    @commands.each do |partymember, skill_info|
      to = skill_info[:target]
      Damage.new(from: partymember, to: to, source: skill_info[:skill]).yield_self do |d|
        @damages << d
        to.damage << d
      end
    end
  end

  def update
    @phase = determine_phase

    if @commands.count == 0 && phase != :round_end
      @decision_start ||= Time.now
    end

    if phase == :round_end && damages.empty?
      assign_damages
    end

    if phase == :assign_enemy_action
      # yolo~~
    end

    if phase == :victory
      @loot ||= LootGenerator.generate(*loot_possibilities)
    end
  end

  def decision_percentage_remaining
    return 100.0 if @decision_start.nil? || phase == :round_end
    return 0.0   if @incorrect_target_chosen || @incorrect_skill_chosen
    computed = 100 - (Time.now - @decision_start) * 100
    computed > 0 ? computed : 0.0
  end

  def remaining_targetable_enemies
    enemies.select { |e| e.current_hp > 0 }
  end

  def loot_possibilities
    [
      { chance: 50, item: 'potion' },
      { chance: 35, item: 'hand grenade' },
      { chance: 15, item: 'golden crown' }
    ]
  end
end
