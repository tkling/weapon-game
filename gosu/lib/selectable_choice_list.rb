# frozen_string_literal: true
class SelectableChoiceList
  def initialize(parent_screen:, choice_mappings:, starting_index: 0)
    @screen = parent_screen
    @choices = choice_mappings
    @choice_index = starting_index
    add_keybinds
  end

  def add_keybinds
    safely_bind Controls::Up,      ->{ increment_choice_index(-1) }
    safely_bind Controls::Down,    ->{ increment_choice_index(1) }
    safely_bind Controls::Confirm, ->{ handle_choice }
  end

  def safely_bind(key, action)
    if @screen.keybinds.key?(key) && @screen.keybinds[key]
      raise "Cannot bind key; it's already bound!"
    else
      @screen.bind(key, action)
    end
  end

  def increment_choice_index(by_amount)
    @choice_index += by_amount
    @choice_index = [0, [@choice_index, @choices.size-1].min].max
  end

  def handle_choice
    @choices[@choice_index][:action].call
  end

  def draw(x:, y_start:, y_spacing:, draw_method: :large_font_draw)
    @screen.window.send(draw_method, x, y_start, y_spacing, Color::YELLOW, *@choices.map { |c| c[:text] })

    selector_y = y_start + y_spacing * @choice_index
    @screen.window.send(draw_method, x-20, selector_y+5, 0, Color::YELLOW, '*')
  end
end
