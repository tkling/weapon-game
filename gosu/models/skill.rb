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
