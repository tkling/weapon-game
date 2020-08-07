class Skill
  attr_accessor :name, :str
  attr_reader :id, :type, :element, :max_level, :xp, :xp_thresholds, :level_modifier

  GAMEDATA_PATH = File.expand_path(File.join(__FILE__, '../../data_ideas/data.json')).freeze

  def self.from_castle_id(id, xp=0)
    @@skills ||= JSON.parse(File.read(GAMEDATA_PATH), symbolize_names: true).yield_self do |game_data|
      game_data[:sheets].select { |sheet| sheet[:name] == 'skills' }.first[:lines]
    end

    @@skills.find { |s| s[:id] == id }.yield_self do |skill|
      new(**skill.merge(xp: xp))
    end
  end

  def level
    xp_thresholds.index(xp_thresholds.select { |amount| amount <= xp }.last) + 1
  end

  def add_xp(xp)
    @xp += xp
  end

  def to_h
    { id: id, xp: xp }
  end

  private
  def initialize(id:, name:, type:, element:, str:, max_level:, xp:, xp_thresholds:, level_modifier:)
    @id, @name, @type, @xp          = id, name, type, xp
    @element, @str, @max_level      = element, str, max_level
    @xp_thresholds, @level_modifier = xp_thresholds, level_modifier
  end
end
