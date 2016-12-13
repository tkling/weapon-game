class Character
  attr_accessor :name, :job, :weapon, :armor, :type, :damage, :items, :base_stats, :target_key

  POSSIBLE_KEY_MAPPINGS = [Gosu::KbQ, Gosu::KbW, Gosu::KbE, Gosu::KbR]

  def initialize(name:, job:, weapon:, armor:, type:, items:, base_stats: Hash.new(1), target_key: nil)
    @name = name
    @job = job
    @armor = armor
    @type = type
    @items = items
    @base_stats = base_stats
    @target_key = target_key
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
    mappings = Hash.new
    weapon.skills.each_with_index do |skill, idx|
      mappings[POSSIBLE_KEY_MAPPINGS[idx]] = skill
    end
    mappings
  end

  def max_hp
    base_stats[:hp] # + armor.hp_bonus ??
  end

  def current_hp
    max_hp - (@damage.map { |dmg| dmg.hit_amount }.reduce(:+) || 0)
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
