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
