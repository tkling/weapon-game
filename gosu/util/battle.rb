# frozen_string_literal: true
class Battle
  attr_reader :battle_order, :party, :enemies, :commands, :damages, :phase, :loot, :xp_tracker

  PHASES = %i[
    select_partymember_skill
    select_partymember_target
    assign_enemy_action
    round_resolution
    round_end
    victory
    defeat
  ].freeze

  def initialize(party, enemies, timer_amount: 3.0)
    @party, @enemies, @timer_amount = party, enemies, timer_amount
    @xp_tracker = ExperienceTracker.new(party + party.map(&:skills).flatten)
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
    party + enemies
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
    command_data = { target: target, decision_percentage_remaining: decision_percentage_remaining }
    commands[current_battle_participant].merge!(command_data)
    @incorrect_target_chosen = false
    @decision_start = nil
    @battle_order_index += 1
  end

  def start_decision
    @decision_start = Time.now
  end

  def determine_phase
    all_commands_taken = commands.all? { |char, com| char && com[:skill] && com[:target] }
    still_battling_participants = battle_order.select { |bp| bp.current_hp.positive? }

    if phase == :round_resolution && commands.empty? && damages.any?
      :round_end
    elsif current_battle_participant.nil? || commands.count == still_battling_participants.count && all_commands_taken
      :round_resolution
    elsif enemies.none? { |ene| ene.current_hp.positive? }
      :victory
    elsif party.none? { |pm| pm.current_hp.positive? }
      :defeat
    elsif party.include?(current_battle_participant) && current_command&.dig(:skill).nil?
      :select_partymember_skill
    elsif party.include?(current_battle_participant) && current_command&.dig(:target).nil?
      :select_partymember_target
    elsif enemies.include?(current_battle_participant)
      :assign_enemy_action
    else
      binding.pry
    end
  end

  def update
    @battle_order_index += 1 if current_battle_participant&.current_hp&.zero?
    @phase = determine_phase

    if [:select_partymember_skill].include?(phase) && @decision_start.nil?
      start_decision
    end

    assign_enemy_action if phase == :assign_enemy_action
    resolve_commands    if phase == :round_resolution

    if phase == :victory
      @loot ||= determine_loot
    end
  end

  def assign_damages
    return if @commands.any? { |_, skill_hash| skill_hash[:target].nil? }
    @commands.each do |char, skill_hash|
      to, skill = skill_hash.values_at(:target, :skill)

      if party.include?(char)
        xp_tracker.add_experience(skill)
        xp_tracker.xp_hash_for(char)[:bonuses] << skill_hash[:decision_percentage_remaining]
      end

      damages << Damage.new(from: char, to: to, source: skill)
    end
    @commands.clear
  end

  def assign_enemy_action
    raise 'not in :assign_enemy_action phase!' unless phase == :assign_enemy_action
    skill = current_battle_participant.weapon.skills.sample
    commands[current_battle_participant] = { skill: skill, target: party.sample }
    @battle_order_index += 1
  end

  def resolve_commands
    assign_damages
    damages.each(&:resolve)
  end

  def decision_percentage_remaining
    return 100.0 if @decision_start.nil? || phase == :round_end
    return 0.0   if @incorrect_target_chosen || @incorrect_skill_chosen
    time_taken = Time.now - @decision_start
    computed = (@timer_amount - time_taken)/@timer_amount
    computed > 0 ? computed : 0.0
  end

  def remaining_targetable_enemies
    enemies.select { |e| e.current_hp > 0 }
  end

  def loot_possibilities
    [
      { chance: 50, item: Item.from_castle_id('item_potion1') },
      { chance: 35, item: Item.from_castle_id('item_attack1') },
      { chance: 15, item: Item.from_castle_id('item_profit1') }
    ]
  end

  def determine_loot
    loot = LootGenerator.generate(*loot_possibilities)
    xp_bonuses = party.map { |pm| @xp_tracker.xp_hash_for(pm)[:bonuses] }.flatten
    should_award_extra = (1..enemies.size*3).to_a.sample < xp_bonuses.sum
    should_award_extra ? loot + LootGenerator.generate(*loot_possibilities) : loot
  end

  def add_awarded_character_experience!
    party.each do |pm|
      xp_tracker.add_experience(pm, character_experience)
    end
  end

  def character_experience
    250
  end
end
