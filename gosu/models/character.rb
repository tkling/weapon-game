# frozen_string_literal: true
class Character
  attr_accessor :name, :job, :weapon, :armor, :type, :damage, :base_stats, :skill_mappings
  attr_reader :current_hp, :status_effects, :xp

  SKILL_KEYBINDS = [Keys::F, Keys::D, Keys::S, Keys::A].freeze

  def initialize(name:, job:, weapon:, armor:, type:, current_hp:, base_stats: Hash.new(1), xp: 0, status_effects: [])
    @name = name
    @job = job.to_sym
    @armor = armor
    @type = type
    @base_stats = base_stats
    @xp = xp
    @current_hp = current_hp
    @status_effects = status_effects
    @weapon = make_weapon weapon
    @armor = make_armor armor
    @skill_mappings = make_skill_mappings
  end

  def make_armor(armor)
    armor.class == Armor ? armor : Armor.from_castle_id(armor[:id])
  end

  def make_weapon(weapon)
    weapon.class == Weapon ? weapon : Weapon.new(**weapon)
  end

  def make_skill_mappings
    weapon.skills.each_with_index.with_object(Hash.new) do |(skill, idx), mappings|
      mappings[SKILL_KEYBINDS[idx]] = skill
    end
  end

  def max_hp
    base_stats[:hp] # + armor.hp_bonus ??
  end

  def dex
    base_stats[:dex]
  end

  def str
    base_stats[:str]
  end

  def int
    base_stats[:int]
  end

  def add_hp(amount)
    result = current_hp + amount
    @current_hp = [0, [result, max_hp].min].max
  end

  def add_xp(amount)
    starting_level = level
    @xp += amount
    handle_level_up if starting_level < level
  end

  def level(additional_xp=0)
    amount_to_consider = xp + additional_xp
    Experience::LevelMap.each_cons(2) do |(lvl, xp_amount), (_, next_xp_amount)|
      return lvl if xp_amount <= amount_to_consider && amount_to_consider < next_xp_amount
    end
  end

  def handle_level_up
    # always award hp and heal awarded amount
    rand(7..19).tap do |new_hp|
      base_stats[:hp] += new_hp
      add_hp(new_hp)
    end

    # guarantee job stat increase
    job_stat_affinity = { knight: :str, rogue: :dex, priest: :int }
    base_stats[job_stat_affinity[job]] += rand(1..3)

    # award 1-2 random stats with +1-3 points
    %i[str dex int].shuffle.take(2).each do |stat|
      base_stats[stat] += rand(1..3)
    end
  end

  def total_atk
    Integer(rand(weapon.base_stats[:damage_range]) * stat_modifier(:str) * 0.6)
  end

  def stat_modifier(stat)
    base_stats[stat] / 100.0 + 1.0
  end

  def skills
    weapon.skills
  end

  def to_h
    {
      name:       name,
      job:        job,
      weapon:     weapon.to_h,
      armor:      armor.to_h,
      type:       type,
      current_hp: current_hp,
      base_stats: base_stats,
      xp:         xp
    }
  end
end
