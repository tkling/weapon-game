# frozen_string_literal: true
class Inventory < GameState
  def initialize(window)
    super
    @item, @target, @highlight_index = nil, nil, 0
    reset_item_choices
    reset_target_choices
    bind_keys
  end

  def bind_keys
    bind Keys::Space, Controls::Cancel, -> { proceed_to CaravanMenu }
    bind Controls::Confirm,             -> { appropriate_choice_list.handle_choice }
    bind Controls::Up,                  -> { appropriate_choice_list.increment_choice_index(-1) }
    bind Controls::Down,                -> { appropriate_choice_list.increment_choice_index(1) }
    bind Keys::Q,                       -> { sort_inventory }
  end

  def appropriate_choice_list
    @selecting_target ? @target_choices : @item_choices
  end

  def use_item_on_character(target_character)
    return unless @selecting_target
    @selecting_target = false
    @target = target_character
    use_item
  end

  def draw
    window.huge_font_draw(10, 10, 0, Color::YELLOW, 'I N V E N T O R Y')
    window.large_font_draw(50, 100, 0, Color::YELLOW, 'item name')

    party_label_x = window.width-250
    window.large_font_draw(party_label_x,     100, 0, Color::YELLOW, 'party')
    window.large_font_draw(party_label_x-120, 100, 0, Color::YELLOW, 'count')

    # item name : count
    x_item, x_count, y_both = 50, party_label_x - 100, 150
    @item_choices.draw(x: x_item, y_start: y_both, y_spacing: 30, draw_method: :normal_font_draw, show_cursor: !@selecting_target)
    @target_choices.draw(x: party_label_x, y_start: 150, y_spacing: 45, show_cursor: @selecting_target)

    if @selecting_target
      window.large_font_draw(window.width/2-200, window.height-200, 0, Color::YELLOW, "Select target for #{@item.name}")
    end

    window.normal_font_draw(window.width/2-100, window.height-160, 30, Color::YELLOW,
      '[e] select item/target', '[q] sort alphabetically', '[space]/[u] return to caravan menu'
    )
  end

  def tallied_inventory_names
    inventory.map(&:name).tally
  end

  def bump_highlight_index(amount)
    @highlight_index += amount
    @highlight_index = 0 if @highlight_index.negative?
    @highlight_index = [@highlight_index, tallied_inventory_names.size - 1].min
  end

  def sort_inventory
    inventory.sort!
    reset_item_choices
  end

  def select_item(item_name)
    found = inventory.find { |i| i.name == item_name }
    raise "failed to find item with name #{item_name} in inventory :(" if found.nil?
    @selecting_target = true
    @item = found
  end

  def reset_item_choices(starting_index = 0)
    @item_choices = SelectableChoiceList.new(
      parent_screen: self,
      starting_index: starting_index,
      raise_on_unsafe_bind: false,
      choice_mappings: tallied_inventory_names.to_a.map do |item_name, count|
        { text: "#{item_name} : #{count < 10 ? "0#{count}" : count}", action: ->{ select_item(item_name) } }
      end)
  end

  def reset_target_choices
    @target_choices = SelectableChoiceList.new(
      parent_screen: self,
      raise_on_unsafe_bind: false,
      choice_mappings: party.map do |pm|
        { text: "#{pm.name} - #{pm.current_hp}/#{pm.max_hp}", action: ->{ use_item_on_character(pm) } }
      end)
  end

  def use_item
    if @item && @target
      @item.apply(@target)
      inventory.delete(@item)
      @target = @item = nil
      reset_item_choices(@item_choices.choice_index)
      reset_target_choices
      bind_keys
    end
  end
end
