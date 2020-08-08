class Item < CastleModel
  attr_reader :name, :description, :value, :effect, :target_count, :default_target, :targetting_type

  def to_h
    { id: id }
  end

  protected
  def initialize(id:, name:, description:, value:, effect: nil, target_count: nil, default_target: nil, targetting_type: nil)
    @id, @name, @description, @value, @effect = id, name, description, value, effect
    @target_count, @default_target, @targetting_type = target_count, default_target, targetting_type
  end
end
