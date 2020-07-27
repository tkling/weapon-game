class LootGenerator
  ROLLS = (0..99).to_a.freeze

  class << self
    def generate(*loot_possibilities)
      loot_chance = loot_possibilities.sum { |lp| lp[:chance] }
      raise "Loot drop chance doesn't equal 100! Computed: #{loot_chance}" unless loot_chance == 100

      range_start = 0
      loot_table = loot_possibilities.map do |lp|
        hash = lp.merge(range: (range_start..lp[:chance] + range_start - 1))
        range_start += lp[:chance]
        hash
      end

      roll = ROLLS.sample
      loot_table.find { |p| p[:range].include?(roll) }.fetch(:item)
    end
  end
end
