class Damage
  attr_reader :from, :to, :source, :hit_amount

  def initialize(from:, to:, source:)
    @from = from
    @to = to
    @source = source
    @hit_amount = compute_hit_amount
  end

  def resolve
    to.add_hp(hit_amount)
  end

  def compute_hit_amount
    #   base weapon damage
    # + skill base damage*skill damage multiplier
    # - to.armor.damage_resist
    from.type == 'partymember' ? -10 : (-5..-1).to_a.sample
  end

  def message
    "#{ from.name }->#{ to.name }: #{ hit_amount} (#{ source.name })"
  end
end
