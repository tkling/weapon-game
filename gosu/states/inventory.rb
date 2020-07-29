class Inventory < GameState
  def key_pressed(id)
    set_next_and_ready(CaravanMenu) if id == Keys::Space
  end

  def draw
    window.huge_font_draw(10, 10, 0, Color::YELLOW, 'I N V E N T O R Y')
    window.large_font_draw(50, 100, 0, Color::YELLOW, 'item name : count')

    x_item, x_count = 50, 500
    y_both = 150

    inventory.tally.each do |item, count|
      count = count < 10 ? ":0#{count}" : ":#{count}"

      window.normal_font_draw(x_item,  y_both, 0, Color::YELLOW, item)
      window.normal_font_draw(x_count, y_both, 0, Color::YELLOW, count)
      y_both += 30
    end

    press_space = 'Press [space] to return to caravan menu.'
    window.large_font_draw(window.width/2-250, window.height-100, 0, Color::YELLOW, press_space)
  end
end
