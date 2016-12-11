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
