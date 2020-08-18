$LOAD_PATH.unshift File.dirname(__FILE__)

require 'json'
require 'pry'
require 'gosu'

require 'lib/constants'
require 'lib/spawning_methods'
require 'lib/save_methods'
require 'models/castle_model'
require 'states/game_state'
require 'util/game_window'
require 'util/loot_generator'
require 'util/experience_tracker'
require 'util/battle'

%w(states models).each do |dir|
  Dir[File.join(File.dirname(__FILE__), dir, '*.rb')].each do |file|
    require file
  end
end

SaveData = Struct.new(:filename, :updated_on, :time_played)
Globals = Struct.new(:party, :map, :save_data, :inventory, :session_begin_time)

game = GameWindow.new
game.show
