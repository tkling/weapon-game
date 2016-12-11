class Dungeon
  attr_accessor :name, :encounter_count, :encounter_index

  def initialize(name:, encounter_count:, encounter_index: 0)
    @name = name
    @encounter_count = encounter_count
    @encounter_index = encounter_index
  end

  def complete?
    encounter_index == encounter_count - 1
  end

  def to_h
    {
      name: name,
      encounter_count: encounter_count,
      encounter_index: encounter_index
    }
  end
end
