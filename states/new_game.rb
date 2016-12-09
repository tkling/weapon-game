class NewGame < GameState
  include SpawningMethods

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
    if Dir[File.join(@save_dir, '*.save')].size >= 9
      @save_count_reached = true
      @time_detected = Time.now
      return
    end

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

    if @save_count_reached
      if Time.now - @time_detected < 2
        @confirmation = 'Only 9 saves allowed, returning to main menu.'
      else
        set_next_and_ready MainMenu
      end
    end
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
    JSON.pretty_generate({
                           players: @window.globals.party.map { |char| char.to_h },
                           time_played: 10
                         })
  end

  def starting_party
    %i(fencer rogue mage).map do |job|
      spawn_starting_hero job
    end
  end
end
