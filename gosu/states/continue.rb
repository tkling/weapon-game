class Continue < GameState
  include SaveMethods

  def initialize(window)
    super window
    @save_map = save_map
    @draw_time = Time.now
  end

  def draw
    window.huge_font_draw(25, 10, 0, Color::YELLOW, 'CHOOSE A SAVE')

    if savefile_paths.size > 0
      starting_key = 0
      subbed = savefile_paths[0..8].map do |filename|
        playtime_str = formatted_time_played JSON.parse(File.read(filename))['time_played']
        "#{starting_key += 1} - #{filename.split('/').last} - playtime: #{playtime_str}"
      end
      window.normal_font_draw(15, 100, 40, Color::YELLOW, *subbed)
    else
      window.large_font_draw(15, 100, 0, Color::YELLOW, 'NO SAVES YET')
      window.normal_font_draw(15, 140, 0, Color::YELLOW, 'Continuing to new game now...')
      @no_saves = true
    end
  end

  def update
    if @no_saves && Time.now - @draw_time > 1
      proceed_to NewGame
    end
  end

  def bind_keys
    (1..9).each do |i|
      key = Module.const_get("Keys::Row#{i}")
      bind key, ->{ load_and_continue(@save_map[key]) }
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

    if players.size > 0
      window.globals.party = players
    else
      raise 'something failed while reading, size 0'
    end
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

  def save_map
    savefile_paths.each_with_index.with_object(Hash.new) do |(filename, idx), map|
      break if idx == 9
      map[Module.const_get("Keys::Row#{idx + 1}")] = filename
    end
  end
end
