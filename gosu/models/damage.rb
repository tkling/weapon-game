class Damage
  attr_reader :from, :to, :hit_amount

  def initialize(from:, to:, source:)
    @from = from
    @to = to
    @source = source
    @hit_amount = compute_hit_amount
  end
end
