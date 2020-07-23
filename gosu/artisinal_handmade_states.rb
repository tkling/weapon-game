$LOAD_PATH.unshift File.dirname(__FILE__)

require 'json'
require 'pry'
require 'gosu'

require 'lib/constants'
require 'lib/spawning_methods'
require 'states/game_state'
require 'util/game_window'

%w(states models).each do |dir|
  Dir[File.join(File.dirname(__FILE__), dir, '*.rb')].each do |file|
    require file
  end
end

SaveData = Struct.new(:filename, :updated_on)
Globals = Struct.new(:party, :map, :save_data)

game = GameWindow.new
game.show
