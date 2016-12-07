# a state has: a name, non-default controls, draw method
require 'constants'
require 'spawning_methods'

class GameState
  def initialize(window)
    @window = window
  end

  def update;          end
  def draw;            end
  def key_pressed(id); end
  def next;            end

  def set_next_and_ready(state_class)
    @next = state_class; notify_ready
  end

  def notify_ready
    @window.ready_to_advance_state!
  end
end

class WelcomeScreen < GameState
  def initialize(window)
    super window
    @vertical_range_array = (20..510).to_a
    @message_y = @vertical_range_array.sample
    @y_set = Time.now
    @message = 'THIS IS WEAPON GAME'
  end

  def update
    if Time.now - @window.start_time > 3.5
      notify_ready
    end
  end

  def draw
    if Time.now - @y_set > 0.25
      @message_y = @vertical_range_array.sample
      @y_set = Time.now
    end

    @window.huge_font_draw(182, @message_y, 0, Color::YELLOW, @message)
  end

  def key_pressed(id)
    if id == Gosu::KbEnter || id == Gosu::KbEscape || id == Gosu::KbSpace
      notify_ready
    end
  end

  def next
    MainMenu
  end
end

class MainMenu < GameState
  def key_pressed(id)
    case id
    when Gosu::KbEscape, Gosu::KbD
      @window.close
    when Gosu::KbQ
      set_next_and_ready NewGame
    when Gosu::KbW
      set_next_and_ready Continue
    when Gosu::KbE
      set_next_and_ready Options
    end
  end

  def next
    @next
  end

  def draw
    header = 'WEAPON GAME MAIN MENU'
    @window.huge_font_draw(45, 20, 0, Color::YELLOW, header)

    new_game = 'q - new game'
    continue = 'w - continue'
    options = 'e - options'
    close = 'd - exit'
    @window.large_font_draw(320, 200, 40, Color::YELLOW, new_game, continue, options, close)
  end
end

class NewGame < GameState
  include SpawningMethods

  require 'json'

  def initialize(window)
    super window
    @save_dir = File.join(window.project_root, 'saves')
    @save_name = "game#{ Dir[File.join(@save_dir, '*')].size + 1 }.save"
    @path = File.join(@save_dir, @save_name)
    @file_created = false
  end

  def key_pressed(id)
    case id
    when Gosu::KbQ
      @file_created ? set_next_and_ready(StartJourney) : make_new_game
    when Gosu::KbE
      set_next_and_ready(MainMenu)
    when Gosu::KbEscape, Gosu::KbSpace
      @window.close
    end
  end

  def make_new_game
    unless File.directory? @save_dir
      Dir.mkdir @save_dir
    end

    unless File.exists? @path
      @window.globals.party = starting_party
      File.write(@path, save_json)
      @file_created = true
    end
  end

  def update
    if @file_created && !@start_journey_set
      @confirmation = 'q to start journey'
      @start_journey_set = true
    end
  end

  def next
    @next
  end

  def draw
    @header           ||= 'N E W G A M E'
    @save_explanation ||= "Your save will be called #{ @save_name }"
    @question         ||= 'Sound good to you?'
    @confirmation     ||= 'q to continue, e to cancel'
    @success          ||= 'S U C C E S S'

    @window.huge_font_draw(   10, 10,  0, Color::YELLOW, @header)
    @window.normal_font_draw(240, 240, 0, Color::YELLOW, @save_explanation)
    @window.normal_font_draw(500, 280, 0, Color::YELLOW, @question)
    @window.normal_font_draw(370, 320, 0, Color::YELLOW, @confirmation)

    if @file_created
      @window.huge_font_draw(420, 520, 0, Color::YELLOW, @success)
    end
  end

  def save_json
    {
      players: @window.globals.party.map { |char| char.to_json },
      time_played: 10
    }.to_json
  end

  def starting_party
    %i(fencer rogue mage).map do |job|
      spawn_starting_hero job
    end
  end
end

class Continue < GameState
  # show game list
  # load selected save
  # if game parts are good then start journey
end

class StartJourney < GameState

end
