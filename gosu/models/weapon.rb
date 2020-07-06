class Weapon
  attr_accessor :name, :type, :skills, :base_stats

  class CannotSetWeaponSkills < StandardError; end

  def initialize(name:, type:, skills:, base_stats: Hash.new(1))
    @name = name
    @type = type
    @skills = set_skills(skills)
    @base_stats = base_stats
  end

  def set_skills(skills)
    if skills.first.is_a?(Skill)
      skills
    elsif skills.first.is_a?(Hash)
      skills.map { |s| Skill.new(s) }
    else
      raise CannotSetWeaponSkills, "skill type is #{skills.first.class}, expected Skill or Hash"
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
