class Character
  attr_accessor :name, :job, :weapon, :armor, :type, :damage, :items, :base_stats, :skill_mappings

  POSSIBLE_KEY_MAPPINGS = [Keys::Q, Keys::W, Keys::E, Keys::R]

  def initialize(name:, job:, weapon:, armor:, type:, items:, base_stats: Hash.new(1))
    @name = name
    @job = job
    @armor = armor
    @type = type
    @items = items
    @base_stats = base_stats
    @damage = []
    @weapon = make_weapon weapon
    @armor = make_armor armor
    @skill_mappings = make_skill_mappings
  end

  def make_armor(armor)
    armor.class == Armor ? armor : Armor.new(armor)
  end

  def make_weapon(weapon)
    weapon.class == Weapon ? weapon : Weapon.new(weapon)
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
    max_hp - (damage.map(&:hit_amount).reduce(:+) || 0)
  end

  def total_atk
    # ugh
    10
  end

  def to_h
    {
      name: name,
      job: job,
      weapon: weapon.to_h,
      armor: armor.to_h,
      type: type,
      items: items,
      base_stats: base_stats
    }
  end
end
