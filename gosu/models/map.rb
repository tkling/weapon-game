class Map
  attr_accessor :name, :dungeons, :dungeon_index

  def initialize(name:, dungeons:, dungeon_index: 0)
    @name = name
    @dungeon_index = dungeon_index
    @dungeons = make_dungeons dungeons
  end

  def make_dungeons(dungeons)
    dungeons.first.class == Dungeon ? dungeons : dungeons.map { |d| Dungeon.new d }
  end

  def completed?
    @dungeon_index == @dungeons.size - 1
  end

  def dungeon
    dungeons[dungeon_index]
  end

  def to_h
    {
      name: name,
      dungeons: dungeons.map { |d| d.to_h },
      dungeon_index: @dungeon_index
    }
  end
end
