# frozen_string_literal: true
class ExperienceTracker
  def initialize(experiencables)
    @entity_map = {}
    experiencables.each { |thing| initialize_entity_entry(thing) }
  end

  def initialize_entity_entry(entity)
    @entity_map[entity] = { starting: entity.xp, awarded: 0, bonuses: [] }
  end

  def add_experience(target_entity, amount=1)
    xp_hash_for(target_entity)[:awarded] += amount
  end

  def award!
    @entity_map.reject { |_, xp_hash| xp_hash[:awarded].nil? }.each do |entity, xp_hash|
      entity.add_xp(determine_awarded_amount(xp_hash))
    end
  end

  def xp_progression_info_for(entity)
    xp_hash_for(entity).yield_self do |xp_hash|
      awarded = determine_awarded_amount(xp_hash)
      {
        starting_xp: xp_hash[:starting],
        starting_level: entity.level,
        xp_after_reward: xp_hash[:starting] + awarded,
        level_after_reward: entity.level(awarded)
      }
    end
  end

  def determine_awarded_amount(xp_hash)
    base = xp_hash[:awarded]
    bonuses = xp_hash[:bonuses]
    computed = base * (bonuses.any? ? (2.0 - bonuses.sum/bonuses.size + 0.25) : 1)
    computed.to_i
  end

  def xp_hash_for(entity)
    @entity_map[entity]
  end
end
