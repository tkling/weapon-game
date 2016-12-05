class Character
  attr_reader :name, :job, :weapon, :armor, :type, :items, :base_stats
  attr_accessor :target_key
  def initialize(name, job, weapon, armor, type, items, base_stats = Hash.new(1), target_key = nil)
    @name = name
    @job = job
    @weapon = weapon
    @armor = armor
    @type = type
    @items = items
    @base_stats = base_stats
    @target_key = target_key
  end
end

class Weapon
  attr_reader :name, :type, :skills, :base_stats
  def initialize(name, type, skills, base_stats = Hash.new(1))
    @name = name
    @type = type
    @skills = skills
    @base_stats = base_stats
  end
end

class Armor
  attr_reader :name, :damage_resist
  def initialize(name, damage_resist)
    @name = name
    @damage_resist = damage_resist
  end
end

class Skill
  attr_reader :name, :element, :base_stats
  def initialize(name, element, base_stats = Hash.new(1))
    @name = name
    @element = element
    @base_stats = base_stats
  end
end

class SkillResolution
  attr_reader :skill, :target, :total_damage, :updated, :owner
  def initialize(skill, owner, target)
    @skill = skill
    @owner = owner
    @target = target
  end

  def update
    @updated = true
    @total_damage = (skill.base_damage_roll - target.armor.damage_resist) * 1.0 # elemental effects?
    target.take_damage(@total_damage)
  end

  def draw(font, x, y, z, color)
    raise 'Cannot draw, not yet updated!' unless updated
    message = "#{ target.name } took #{ @total_damage } damage from #{ skill.owner.name }'s #{ skill.name } and has #{ target.hp } HP left!"
    font.draw(message, x, y, z, 1.0, 1.0, color)
  end
end

module SpawningMethods
  def job_types
    @job_types ||= %i(fencer rogue mage)
  end

  def weapon_types
    @weapon_types ||= %i(longsword spear dagger staff)
  end

  def random_weapon
    @adjectives ||= %w(Brave Humiliating Embarassing All-Encompassing Shy Tasty Distasteful)
    @nouns ||= %w(Whipper-Snapper Slicer Maul Axe Bomba Chopsticks)
    name = "#{ @adjectives.sample } #{ @nouns.sample }"
    low_damage = random_from_range(1..10)
    high_damage = random_from_range(8..25)
    Weapon.new(name, weapon_types.sample, [:strike], damage_range: (low_damage..high_damage))
  end

  def random_armor
    Armor.new('Basic Armor', 5)
  end

  def spawn_characters(count)
    count.times.map do |idx|
      Character.new("Hero#{ idx }", job_types[idx],
                    random_weapon, random_armor, :partymember, [],
                    hp: random_from_range(14..30))
    end
  end

  def spawn_enemies(count)
    count.times.map do |idx|
      Character.new("Enemy#{ idx }", job_types[idx],
                    random_weapon, random_armor, :enemy, [],
                    hp: random_from_range(10..27))
    end
  end

  def random_from_range(range)
    range.to_a.sample
  end
end
