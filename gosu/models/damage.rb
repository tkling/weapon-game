class Damage
  attr_reader :from, :to, :hit_amount

  def initialize(from:, to:, source:, hit_amount:)
    @from = from
    @to = to
    @source = source
    @hit_amount = hit_amount
  end
end
