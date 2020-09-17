class Weapon
  attr_accessor :name, :type, :skills, :base_stats

  class CannotSetWeaponSkills < StandardError; end

  def initialize(name:, type:, skills:, base_stats: Hash.new(1))
    @name = name
    @type = type
    @skills = determine_skills(skills)
    @base_stats = base_stats
    @base_stats[:damage_range] = hydrate_damage_range(@base_stats[:damage_range])
  end

  def determine_skills(skills)
    case skills.first
    when Skill then skills
    when Hash  then skills.map { |s| Skill.from_castle_id(s[:id], xp: s[:xp]) }
    else raise CannotSetWeaponSkills, "skill type is #{skills.first.class}, expected Skill or Hash"
    end
  end

  def hydrate_damage_range(dr)
    case dr
    when String then Range.new(*dr.split('..').map(&:to_i))
    when Range then dr
    else raise "damage_range isn't a string or a range, it's a #{dr.class}!"
    end
  end

  def to_h
    {
      name: name,
      type: type,
      skills: skills.map(&:to_h),
      base_stats: base_stats
    }
  end
end
