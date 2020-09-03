class Armor < CastleModel
  attr_reader :id, :name, :damage_resist, :element

  def to_h
    { id: id }
  end

  protected
  def initialize(id:, name:, damage_resist:, element: Elements::Neutral)
    @id = id
    @name = name
    @damage_resist = damage_resist
    @element = element
  end
end
