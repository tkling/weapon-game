# frozen_string_literal: true
class CastleModel
  GAMEDATA_PATH = File.expand_path(File.join(__FILE__, '../../data_ideas/data.json')).freeze
  PARSED_DATA = JSON.parse(File.read(GAMEDATA_PATH), symbolize_names: true)[:sheets].freeze
  SHEETS = {}

  class << self
    def all_castle_ids
      sheet_lines.map { |t| t[:id] }
    end

    def from_castle_id(id, args={})
      sheet_lines.find { |t| t[:id] == id }.yield_self do |row_data|
        new(**args.merge(row_data))
      end
    end

    def sheet_lines
      SHEETS[self.name] ||= PARSED_DATA.find { |sheet| sheet[:name] == "#{self.name.downcase}s" }[:lines]
    end
  end

  protected
  def initialize(**args)
    raise 'must override!'
  end
end
