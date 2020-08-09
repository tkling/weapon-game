class Item < CastleModel
  attr_reader :id, :name, :description, :value, :effect, :target_count, :default_target, :targeting_type

  def to_h
    { id: id }
  end

  def apply(*targets)
    return if effect.nil?
    targeted_field, operator, value = effect.split(' ')
    targets.each do |target|
      target.method("add_#{targeted_field}").call(Integer(operator + value))
    end
  end

  protected
  def initialize(id:, name:, description:, value:, effect: nil, target_count: nil, default_target: nil, targeting_type: nil)
    @id, @name, @description, @value, @effect = id, name, description, value, effect
    @target_count, @default_target, @targetting_type = target_count, default_target, targeting_type
  end
end
