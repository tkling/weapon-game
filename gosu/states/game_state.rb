class GameState
  attr_reader :window, :keybinds, :next

  def initialize(window) # use GameWindow.instance here
    @window = window
    @keybinds = {}
  end

  def update;    end
  def draw;      end
  def bind_keys; end

  def setup = bind_keys
  def bind(*keys, action) = keys.each {|key| @keybinds[key] = action }
  def key_pressed(key) = @keybinds[key]&.call

  def handle_global_keypresses(id)
    @global_keybinds ||= {
      Keys::F1     => ->{ proceed_to MainMenu },
      Keys::F5     => ->{ binding.pry },
      Keys::Escape => ->{ window.close }
    }[id]&.call
  end

  def proceed_to(state_class_or_instance)
    @next = state_class_or_instance
    window.ready_to_advance_state!
  end

  def map       = window.globals.map
  def party     = window.globals.party
  def inventory = window.globals.inventory
  def dungeon   = map.dungeon
  def enemies   = dungeon.encounters[dungeon.encounter_index]

  def formatted_time_played(seconds=nil)
    seconds ||= Time.now - window.globals.session_begin_time + window.globals.save_data.time_played
    @two_digit_padded ||= ->(num) { num < 10 ? "0#{num}" : num }
    (seconds.round/60.0).to_s.split('.').yield_self do |min, sec_p|
      "#{@two_digit_padded.call(Integer(min))}:#{@two_digit_padded.call((Float('0.'+sec_p)*60.0).round)}"
    end
  end
end
