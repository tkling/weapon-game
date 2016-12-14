class Damage
  attr_reader :from, :to, :hit_amount

  def initialize(from:, to:, source:)
    @from = from
    @to = to
    @source = source
    @hit_amount = compute_hit_amount
  end

  def compute_hit_amount
    #   base weapon damage
    # + skill base damage*skill damage multiplier
    # - to.armor.damage_resist
    10
  end
end
