class Inventory < GameState
  TARGET_KEYS = {
    Keys::J => 'j',
    Keys::K => 'k',
    Keys::L => 'l'
  }.freeze

  def initialize(window)
    super
    @item, @target, @highlight_index = nil, nil, 0
  end

  def bind_keys
    bind Keys::Space, -> { proceed_to CaravanMenu }
    bind Keys::Q,     -> { sort_inventory }
    bind Keys::E,     -> { select_target }
    bind Keys::Up,    -> { bump_highlight_index(-1); select_item }
    bind Keys::Down,  -> { bump_highlight_index(1);  select_item }

    @target_mapping = TARGET_KEYS.keys.zip(party).to_h.freeze
    @target_mapping.keys.each do |key|
      bind key, -> { handle_target(key) }
    end
  end

  def select_target
    return if @item.nil?
    @selecting_target = true
  end

  def handle_target(keypress)
    return unless @selecting_target && @target_mapping.key?(keypress) && @target_mapping[keypress]
    @selecting_target = false
    @target = @target_mapping[keypress]
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
    tallied_inventory_names.each.with_index do |(item, count), idx|
      count = count < 10 ? ":0#{count}" : ":#{count}"
      item = "* #{item}" if @highlight_index == idx

      window.normal_font_draw(x_item,  y_both, 0, Color::YELLOW, item)
      window.normal_font_draw(x_count, y_both, 0, Color::YELLOW, count)
      y_both += 30
    end

    # keypress - partymember - hp
    window.normal_font_draw(party_label_x, 150, 45, Color::YELLOW, *@target_mapping.map do |keypress, partymember|
      name_label = "#{TARGET_KEYS[keypress] + ' - ' if @selecting_target}#{partymember.name}"
      "#{name_label} - #{partymember.current_hp}/#{partymember.max_hp}"
    end)

    if @selecting_target
      window.large_font_draw(window.width/2-200, window.height-200, 0, Color::YELLOW, "Select target for #{@item.name}")
    end

    window.normal_font_draw(window.width/2-100, window.height-160, 30, Color::YELLOW,
      '[e] select item', '[q] sort alphabetically', '[space] return to caravan menu'
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
  end

  def select_item
    name_pair = tallied_inventory_names.to_a[@highlight_index]
    return bump_highlight_index(-1) && select_item if name_pair.nil? || name_pair.size != 2
    @item = inventory.find { |i| i.name == name_pair.first }
  end

  def use_item
    if @item && @target
      @item.apply(@target)
      inventory.delete(@item)
      @target = nil
      select_item
    end
  end
end
