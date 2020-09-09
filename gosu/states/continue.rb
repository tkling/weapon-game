class Continue < GameState
  include SaveMethods

  def initialize(window)
    super window
    @draw_time = Time.now
    @savefile_count = savefile_paths.size
    @choice_list = SelectableChoiceList.new(
      parent_screen: self,
      draw_method: :normal_font_draw,
      choice_mappings: savefile_paths.map.with_index do |filename, idx|
        { text: savefile_display_string(filename, idx+1), action: ->{ load_and_continue(filename) } }
      end
    )
  end

  def savefile_display_string(filename, slot_number)
    playtime = formatted_time_played JSON.parse(File.read(filename))['time_played']
    "#{slot_number} - #{filename.split('/').last} - playtime: #{playtime}"
  end

  def draw
    window.huge_font_draw(25, 10, 0, Color::YELLOW, 'CHOOSE A SAVE')

    if @savefile_count.positive?
      @choice_list.draw(x: 50, y_start: 100, y_spacing: 40)
    else
      window.large_font_draw(15, 100, 0, Color::YELLOW, 'NO SAVES YET')
      window.normal_font_draw(15, 140, 0, Color::YELLOW, 'Continuing to new game now...')
    end
  end

  def update
    if @savefile_count.zero? && Time.now - @draw_time > 1
      proceed_to NewGame
    end
  end

  def load_and_continue(filename)
    return unless filename && File.exist?(filename)
    save_hash = JSON.parse(File.read(filename), symbolize_names: true)
    set_party_from_hash     save_hash
    set_map_from_hash       save_hash
    set_inventory_from_hash save_hash
    window.globals.save_data.filename = filename.split('/').last
    window.globals.save_data.time_played = save_hash[:time_played]
    window.globals.session_begin_time = Time.now
    proceed_to              StartJourney
  end

  def set_party_from_hash(hash)
    players = hash[:players].map do |character_info|
      Character.new **character_info
    end

    raise 'something failed while reading, party size is 0' if players.size.zero?
    window.globals.party = players
  end

  def set_map_from_hash(hash)
    window.globals.map = Map.new **hash[:map]
  rescue StandardError => e
    bt = e.backtrace # something bad when loading map
    binding.pry
  end

  def set_inventory_from_hash(hash)
    window.globals.inventory = hash[:inventory]&.map { |item_hash| Item.from_castle_id(item_hash[:id]) } || []
  end
end
