class Damage
  attr_reader :from, :to, :source, :hit_amount

  def initialize(from:, to:, source:, crit_chance_modifier:)
    @from = from
    @to = to
    @source = source
    @crit_chance_modifier = crit_chance_modifier
    @attributes = { miss: should_miss?, crit: should_crit? }
    @hit_amount = compute_hit_amount
  end

  def resolve
    to.add_hp(hit_amount)
  end

  def compute_hit_amount
    # Something to consider: every turn-based RPG I can think of doesn't use explicit weapon/armor for enemies. Or
    # at least they don't make it known/obvious if enemies have similar equipables to what are available to player
    # characters. It could potentially simplify things to have element/resist/damage directly on enemies rather than
    # coming from their equipables. Then again there's a nice simplicity to players and enemies sharing the same code.
    return 0 if @attributes[:miss]
    damage = from.type == 'partymember' ? -10 : (-5..-1).to_a.sample
    damage = damage * Elements::AffinityMap[source.element][to.armor.element]
    damage = damage * source.level_damage_multiplier
    damage = damage * (100 - to.armor.damage_resist) / 100
    damage = @attributes[:crit] ? damage * 1.25 : damage
    damage = damage.round(half: :up).to_i
    damage == 0 ? 1 : damage
  end

  def should_miss?
    # placeholder for now, later base this on comparing from vs to dex, maybe also status effects
    false
  end

  def should_crit?
    # add character's (from) crit chance stat here at some point
    @crit_chance_modifier * 25 + 1.0 > rand(1..100)
  end

  def message
    "#{from.name} -> #{to.name}: #{hit_amount} (#{source.name} [#{source.level}])"
  end
end
