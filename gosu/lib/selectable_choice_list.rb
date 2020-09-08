# frozen_string_literal: true
class SelectableChoiceList
  attr_reader :choice_index

  def initialize(parent_screen:, choice_mappings:, starting_index: 0, raise_on_unsafe_bind: true)
    @screen = parent_screen
    @choices = choice_mappings
    @choice_index = starting_index
    @raise_on_unsafe_bind = raise_on_unsafe_bind
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
    ensure_index_within_bounds
  end

  def ensure_index_within_bounds
    @choice_index = [0, [@choice_index, @choices.size-1].min].max
  end

  def handle_choice
    @choices[@choice_index][:action].call
    increment_choice_index(-1) if @choice_index >= @choices.size
  end

  def draw(x:, y_start:, y_spacing:, draw_method: :large_font_draw, show_cursor: true)
    return unless @choices.size.positive?
    @screen.window.send(draw_method, x, y_start, y_spacing, Color::YELLOW, *@choices.map { |c| c[:text] })

    if show_cursor
      selector_y = y_start + y_spacing * @choice_index
      @screen.window.send(draw_method, x-20, selector_y+5, 0, Color::YELLOW, '*')
    end
  end
end
