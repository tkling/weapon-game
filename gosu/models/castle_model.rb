# frozen_string_literal: true
class CastleModel
  GAMEDATA_PATH = File.expand_path(File.join(__FILE__, '../../data_ideas/data.json')).freeze
  PARSED_DATA = JSON.parse(File.read(GAMEDATA_PATH), symbolize_names: true)[:sheets].freeze
  SHEETS = {}

  def self.from_castle_id(id, args={})
    SHEETS[self.name] ||= PARSED_DATA.find { |sheet| sheet[:name] == "#{self.name.downcase}s" }[:lines]
    SHEETS[self.name].find { |t| t[:id] == id }.yield_self do |data|
      new(**args.merge(data))
    end
  end

  protected
  def initialize(**args)
    raise 'must override!'
  end
end
