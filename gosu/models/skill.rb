class Skill < CastleModel
  attr_accessor :name, :str
  attr_reader :id, :type, :element, :max_level, :xp, :xp_thresholds, :level_modifier

  def level(additional=0)
    amount_to_consider = xp + additional
    xp_thresholds.index(xp_thresholds.select { |amount| amount <= amount_to_consider }.last) + 1
  end

  def add_xp(xp)
    @xp += xp
  end

  def to_h
    { id: id, xp: xp }
  end

  protected
  def initialize(id:, name:, type:, element:, str:, max_level:, xp: 0, xp_thresholds:, level_modifier:)
    @id, @name, @type, @xp          = id, name, type, xp
    @element, @str, @max_level      = element, str, max_level
    @xp_thresholds, @level_modifier = xp_thresholds, level_modifier
  end
end
