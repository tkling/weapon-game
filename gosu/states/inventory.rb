# frozen_string_literal: true
class Inventory < GameState
  def initialize(window)
    super
    reset_and_rebind_choices
  end

  def reset_and_rebind_choices(item_choices_index: 0)
    reset_item_choices(item_choices_index)
    reset_target_choices
    bind_keys
  end

  def reset_item_choices(starting_index)
    @item_choices = SelectableChoiceList.new(
      starting_index: starting_index,
      raise_on_unsafe_bind: false,
      choice_mappings: tallied_inventory_names.to_a.map do |item_name, _|
        { text: item_name, action: ->{ select_item(item_name) } }
      end)
  end

  def reset_target_choices
    @target_choices = SelectableChoiceList.new(
      raise_on_unsafe_bind: false,
      choice_mappings: party.map do |pm|
        { text: "#{pm.name} - #{pm.current_hp}/#{pm.max_hp}", action: ->{ use_item_on_character(pm) } }
      end)
  end

  def bind_keys
    bind Keys::Space,       -> { proceed_to CaravanMenu }
    bind Controls::Confirm, -> { appropriate_choice_list.handle_choice }
    bind Controls::Cancel,  -> { @item = @selecting_target = nil }
    bind Controls::Up,      -> { appropriate_choice_list.increment_choice_index(-1) }
    bind Controls::Down,    -> { appropriate_choice_list.increment_choice_index(1) }
    bind Keys::S,           -> { sort_inventory }
  end

  def appropriate_choice_list
    @selecting_target ? @target_choices : @item_choices
  end

  def tallied_inventory_names
    inventory.map(&:name).tally
  end

  def sort_inventory
    inventory.sort_by!(&:name)
    reset_and_rebind_choices(item_choices_index: @item_choices.choice_index)
  end

  def select_item(item_name)
    found = inventory.find { |i| i.name == item_name }
    raise "failed to find item with name #{item_name} in inventory :(" if found.nil?
    @selecting_target = true
    @item = found
  end

  def use_item_on_character(target_character)
    return unless @selecting_target && @item
    @selecting_target = false
    @item.apply(target_character)
    inventory.delete(@item)
    @item = nil
    reset_and_rebind_choices(item_choices_index: @item_choices.choice_index)
  end

  def draw
    @item_count_spacing ||= 30
    @party_label_x      ||= window.width-250
    @x_item             ||= 50
    @x_count            ||= @party_label_x - 90
    @y_both             ||= 150
    @heading_y          ||= 100

    window.huge_font_draw(10, 10, 0, Color::YELLOW, 'I N V E N T O R Y')
    window.large_font_draw(@x_item,            @heading_y, 0, Color::YELLOW, 'item name')
    window.large_font_draw(@party_label_x,     @heading_y, 0, Color::YELLOW, 'party')
    window.large_font_draw(@party_label_x-120, @heading_y, 0, Color::YELLOW, 'count')
    window.normal_font_draw(@x_count, @y_both, @item_count_spacing, Color::YELLOW,
                            *tallied_inventory_names.to_a.map { |_, count| count })

    @item_choices.draw(x: @x_item, y_start: @y_both, y_spacing: @item_count_spacing, show_cursor: !@selecting_target)
    @target_choices.draw(x: @party_label_x, y_start: @y_both, y_spacing: 45, show_cursor: @selecting_target)

    if @selecting_target
      window.large_font_draw(window.width/2-200, window.height-200, 0, Color::YELLOW, "Select target for #{@item.name}")
    end

    window.normal_font_draw(window.width/2-100, window.height-160, 30, Color::YELLOW,
      '[e] select item/target', '[u] cancel item usage', '[s] sort alphabetically', '[space] return to caravan menu')
  end
end
