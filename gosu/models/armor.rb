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
