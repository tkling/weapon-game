class Dungeon
  attr_accessor :name, :encounters, :encounter_index

  def initialize(name:, encounters:, encounter_index: 0)
    @name = name
    @encounters = if encounters.first.first.class == Hash
                    encounters.map { |enemies| enemies.map { |e| Character.new(**e) } }
                  else
                    encounters
                  end
    @encounter_index = encounter_index
  end

  def complete?
    encounter_index == encounters.size - 1 && encounter.sum(&:current_hp) <= 0
  end

  def encounter
    encounters[encounter_index]
  end

  def to_h
    {
      name: name,
      encounters: encounters.map { |enc| enc.map(&:to_h) },
      encounter_index: encounter_index
    }
  end
end
