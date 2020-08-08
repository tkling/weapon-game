class Character
  attr_accessor :name, :job, :weapon, :armor, :type, :damage, :base_stats, :skill_mappings, :xp

  POSSIBLE_KEY_MAPPINGS = [Keys::Q, Keys::W, Keys::E, Keys::R]

  def initialize(name:, job:, weapon:, armor:, type:, base_stats: Hash.new(1), xp: 0)
    @name = name
    @job = job
    @armor = armor
    @type = type
    @base_stats = base_stats
    @xp = xp
    @damage = []
    @weapon = make_weapon weapon
    @armor = make_armor armor
    @skill_mappings = make_skill_mappings
  end

  def make_armor(armor)
    armor.class == Armor ? armor : Armor.new(**armor)
  end

  def make_weapon(weapon)
    weapon.class == Weapon ? weapon : Weapon.new(**weapon)
  end

  def make_skill_mappings
    weapon.skills.each_with_index.with_object(Hash.new) do |(skill, idx), mappings|
      mappings[POSSIBLE_KEY_MAPPINGS[idx]] = skill
    end
  end

  def max_hp
    base_stats[:hp] # + armor.hp_bonus ??
  end

  def current_hp
    [max_hp - damage.map(&:hit_amount).sum, 0].max
  end

  def level
    Experience::LevelMap.each_cons(2) do |(lvl, xp_amount), (_, next_xp_amount)|
      return lvl if xp_amount <= xp  && xp < next_xp_amount
    end
  end

  def total_atk
    # ugh
    10
  end

  def xp_progression_info(xp_amount)
    {
      starting_xp: xp.dup,
      starting_level: level.dup,
      xp_after_reward: @xp += xp_amount,
      level_after_reward: level
    }
  end

  def to_h
    {
      name: name,
      job: job,
      weapon: weapon.to_h,
      armor: armor.to_h,
      type: type,
      base_stats: base_stats,
      xp: xp
    }
  end
end
