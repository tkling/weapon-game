class Dungeon
  attr_accessor :name, :encounters, :encounter_index

  def initialize(name:, encounters:, encounter_index: 0)
    @name = name
    @encounters = encounters
    @encounter_index = encounter_index
  end

  def complete?
    encounter_index == encounters.size - 1
  end

  def to_h
    {
      name: name,
      encounters: encounters.map { |enc| enc.map(&:to_h) },
      encounter_index: encounter_index
    }
  end

end
