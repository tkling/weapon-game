require 'json'

class Character
  attr_accessor :name, :job, :weapon, :armor, :type, :items, :base_stats, :target_key
  def initialize(name:, job:, weapon:, armor:, type:, items:, base_stats: Hash.new(1), target_key: nil)
    @name = name
    @job = job
    @weapon = weapon
    @armor = armor
    @type = type
    @items = items
    @base_stats = base_stats
    @target_key = target_key
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

class Weapon
  attr_accessor :name, :type, :skills, :base_stats
  def initialize(name:, type:, skills:, base_stats: Hash.new(1))
    @name = name
    @type = type
    @skills = skills
    @base_stats = base_stats
  end

  def to_h
    {
      name: name,
      type: type,
      skills: skills.map { |s| s.to_h },
      base_stats: base_stats
    }
  end
end

class Armor
  attr_accessor :name, :damage_resist
  def initialize(name:, damage_resist:)
    @name = name
    @damage_resist = damage_resist
  end

  def to_h
    {
      name: name,
      damage_resist: damage_resist
    }
  end
end

class Skill
  attr_accessor :name, :element, :base_stats
  def initialize(name:, element:, base_stats: Hash.new(1))
    @name = name
    @element = element
    @base_stats = base_stats
  end

  def to_h
    {
      name: name,
      element: element,
      base_stats: base_stats
    }
  end
end

class SkillResolution
  attr_accessor :skill, :target, :total_damage, :updated, :owner
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
