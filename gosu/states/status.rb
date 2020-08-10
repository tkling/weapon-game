# frozen_string_literal: true
class Status < GameState
  def bind_keys
    bind Keys::Space, ->{ proceed_to CaravanMenu }
  end

  def draw
    window.huge_font_draw(10, 10, 0, Color::YELLOW, 'S T A T U S')

    window.large_font_draw( 35, 150,  0,  Color::YELLOW, 'party:')
    window.large_font_draw(150, 200, 50, Color::YELLOW, *party.map do |pm|
      "#{pm.name} - level #{pm.level} - hp: #{pm.current_hp}/#{pm.max_hp} - xp: #{pm.xp}/#{Experience::LevelMap[pm.level+1]}"
    end)

    window.normal_font_draw(window.width/2-150, window.height/2+200, 0, Color::YELLOW, '[space] return to caravan menu')
  end
end
