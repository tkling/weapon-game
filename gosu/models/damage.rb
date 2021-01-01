class Damage
  attr_reader :from, :to, :source, :hit_amount

  def initialize(from:, to:, source:, crit_chance_modifier:)
    @from = from
    @to = to
    @source = source
    @resolved = false
    @hit_amount = compute_hit_amount(crit_chance_modifier)
  end

  def resolve
    to.add_hp(hit_amount)
    @resolved = true
  end

  def resolved?
    @resolved
  end

  def compute_hit_amount(crit_chance_modifier)
    # Something to consider: every turn-based RPG I can think of doesn't use explicit weapon/armor for enemies. Or
    # at least they don't make it known/obvious if enemies have similar equipables to what are available to player
    # characters. It could potentially simplify things to have element/resist/damage directly on enemies rather than
    # coming from their equipables. Then again there's a nice simplicity to players and enemies sharing the same code.
    return 0 if should_miss?
    damage = from.type == 'partymember' ? from.total_atk * -2 : rand(-5..-1)
    damage = damage * Elements::AffinityMap[source.element][to.armor.element]
    damage = damage * source.level_damage_multiplier
    damage = damage * (100 - to.armor.damage_resist) / 100
    damage = damage * (should_crit?(crit_chance_modifier) ? 1.25 : 1)
    damage = damage.round(half: :up).to_i
    [damage, -1].min
  end

  def should_miss?
    return @should_miss unless @should_miss.nil?
    base = from.dex < to.dex ? 30 : 45
    @should_miss = from.stat_modifier(:dex) * 2 * base < rand(1..100)
  end

  def should_crit?(chance_modifier=:noop)
    return @should_crit unless @should_crit.nil?
    return (@should_crit = false) if should_miss?
    @should_crit = from.dex / 10 * 2 + chance_modifier * 25 + 1.0 > rand(1..100)
  end

  def message
    "#{from.name} -> #{to.name}: #{damage_amount_string} (#{source.name} [#{source.level}])"
  end

  def damage_amount_string
    if should_miss?
      'missed!'
    elsif should_crit?
      "crit! #{hit_amount}"
    else
      hit_amount.to_s
    end
  end
end
