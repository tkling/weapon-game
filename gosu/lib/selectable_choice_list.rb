# frozen_string_literal: true
class SelectableChoiceList
  attr_reader :choice_index, :choices, :draw_method

  def initialize(parent_screen: GameWindow.instance.state, choice_mappings:, starting_index: 0,
                 raise_on_unsafe_bind: true, draw_method: :normal_font_draw)
    @screen = parent_screen
    @choices = choice_mappings
    @choice_index = starting_index
    @raise_on_unsafe_bind = raise_on_unsafe_bind
    @draw_method = draw_method
    ensure_index_within_bounds
    add_keybinds
  end

  def add_keybinds
    safely_bind Controls::Up,      ->{ increment_choice_index(-1) }
    safely_bind Controls::Down,    ->{ increment_choice_index(1) }
    safely_bind Controls::Confirm, ->{ handle_choice }
  end

  def safely_bind(key, action)
    if @raise_on_unsafe_bind && @screen.keybinds.key?(key) && @screen.keybinds[key]
      raise "Cannot bind key; it's already bound!"
    else
      @screen.bind(key, action)
    end
  end

  def increment_choice_index(by_amount)
    @choice_index += by_amount
    @choice_index = 0 if choice_index >= choices.size
    @choice_index = choices.size - 1 if choice_index < 0
  end

  def ensure_index_within_bounds
    @choice_index = choice_index.clamp(0, choices.size-1)
  end

  def handle_choice
    choices[choice_index][:action].call
    increment_choice_index(-1) if choice_index >= choices.size
  end

  def draw(x:, y:, y_space:, show_cursor: true)
    return unless choices.size.positive?
    lables = choices.map {|c| c[:text] }
    @screen.window.send(draw_method, x, y, y_space, *lables)

    if show_cursor
      selector_y = y + y_space * choice_index
      @screen.window.send(draw_method, x-20, selector_y+5, 0, '*')
    end
  end
end
