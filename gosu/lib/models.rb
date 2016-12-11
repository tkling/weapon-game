class Map
  attr_accessor :name, :dungeons, :dungeon_index

  def initialize(name:, dungeons:, dungeon_index: 0)
    @name = name
    @dungeon_index = dungeon_index
    @dungeons = make_dungeons dungeons
  end

  def make_dungeons(dungeons)
    if dungeons.first.class == Hash
      dungeons.map { |d| Dungeon.new d }
    else
      dungeons
    end
  end

  def completed?
    @dungeon_index == @dungeons.size - 1
  end

  def dungeon
    dungeons[dungeon_index]
  end

  def to_h
    {
      name: name,
      dungeons: dungeons.map { |d| d.to_h },
      dungeon_index: @dungeon_index
    }
  end
end

class Dungeon
  attr_accessor :name, :encounter_count, :encounter_index

  def initialize(name:, encounter_count:, encounter_index: 0)
    @name = name
    @encounter_count = encounter_count
    @encounter_index = encounter_index
  end

  def complete?
    encounter_index == encounter_count - 1
  end

  def to_h
    {
      name: name,
      encounter_count: encounter_count,
      encounter_index: encounter_index
    }
  end
end

class Character
  attr_accessor :name, :job, :weapon, :armor, :type, :items, :base_stats, :target_key

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
  end

  def make_armor(armor)
    if armor.class == Hash
      Armor.new armor
    else
      armor
    end
  end

  def make_weapon(weapon)
    if weapon.class == Hash
      Weapon.new weapon
    else
      weapon
    end
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
