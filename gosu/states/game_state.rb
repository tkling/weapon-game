class GameState
  attr_reader :window

  def initialize(window)
    @window = window
    @keybinds = {}
    bind_keys
  end

  def update;          end
  def draw;            end
  def bind_keys;       end

  def bind(key, action)
    @keybinds[key] = action
  end

  def key_pressed(key)
    @keybinds[key]&.call
  end

  def handle_global_keypresses(id)
    set_next_and_ready(MainMenu) if id == Keys::F1
    binding.pry                  if id == Keys::F5
    window.close                 if id == Keys::Escape
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

  def current_enemies
    dungeon.encounters[dungeon.encounter_index]
  end
end
