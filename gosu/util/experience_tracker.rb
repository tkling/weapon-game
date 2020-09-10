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
    @entity_map[target_entity][:awarded] += amount
  end

  def award!
    @entity_map.reject { |_, xp_hash| xp_hash[:awarded].nil? }.each do |entity, xp_hash|
      entity.add_xp(determine_awarded_amount(xp_hash))
    end
  end

  def xp_progression_info_for(entity)
    @entity_map[entity].yield_self do |entry|
      {
        starting_xp: entry[:starting],
        starting_level: entity.level,
        xp_after_reward: entry[:starting] + determine_awarded_amount(entry),
        level_after_reward: entity.level(entry[:awarded])
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
