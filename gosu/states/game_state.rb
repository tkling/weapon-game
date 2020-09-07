class GameState
  attr_reader :window, :keybinds

  def initialize(window)
    @window = window
    @keybinds = {}
    bind_keys
  end

  def update;          end
  def draw;            end
  def bind_keys;       end

  def bind(*keys, action)
    keys.each do |key|
      @keybinds[key] = action
    end
  end

  def key_pressed(key)
    @keybinds[key]&.call
  end

  def handle_global_keypresses(id)
    @global_keybinds ||= {
      Keys::F1     => ->{ proceed_to MainMenu },
      Keys::F5     => ->{ binding.pry },
      Keys::Escape => ->{ window.close }
    }

    @global_keybinds[id]&.call
  end

  def next
    @next
  end

  def set_next_and_ready(state_class)
    @next = state_class
    notify_ready
  end
  alias_method :proceed_to, :set_next_and_ready

  def notify_ready
    window.ready_to_advance_state!
  end

  def map
    window.globals.map
  end

  def party
    window.globals.party
  end

  def inventory
    window.globals.inventory
  end

  def dungeon
    map.dungeon
  end

  def enemies
    dungeon.encounters[dungeon.encounter_index]
  end

  def formatted_time_played(seconds=Time.now - window.globals.session_begin_time + window.globals.save_data.time_played)
    @two_digit_padded ||= ->(num) { num < 10 ? "0#{num}" : num }
    (seconds.round/60.0).to_s.split('.').yield_self do |min, sec_p|
      "#{@two_digit_padded.call(Integer(min))}:#{@two_digit_padded.call((Float('0.'+sec_p)*60.0).round)}"
    end
  end
end
