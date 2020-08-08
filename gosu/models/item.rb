class Item
  attr_reader :name, :description, :value, :effect, :target_count, :default_target, :targetting_type

  GAMEDATA_PATH = File.expand_path(File.join(__FILE__, '../../data_ideas/data.json')).freeze

  def self.from_castle_id(id)
    @items ||= JSON.parse(File.read(GAMEDATA_PATH), symbolize_names: true).yield_self do |game_data|
      game_data[:sheets].select { |sheet| sheet[:name] == 'items' }.first[:lines]
    end

    @items.find { |i| i[:id] == id }.yield_self do |item|
      new(**item)
    end
  end

  def to_h
    { id: id }
  end

  private
  def initialize(id:, name:, description:, value:, effect: nil, target_count: nil, default_target: nil, targetting_type: nil)
    @id, @name, @description, @value, @effect = id, name, description, value, effect
    @target_count, @default_target, @targetting_type = target_count, default_target, targetting_type
  end
end
