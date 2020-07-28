class MapCompleted < GameState
  def draw
    window.huge_font_draw(10, 10, 0, Color::YELLOW, 'J O U R N E Y C O M P L E T E !')
    window.large_font_draw(100, 160, 0, Color::YELLOW, 'Final XP amounts:')

    partymember_xp_messages = party.map do |partymember|
      "#{partymember.name}: Level #{partymember.level}, total XP: #{partymember.xp}"
    end

    window.large_font_draw(window.width/2-200, window.height/4+50, 35, Color::YELLOW, *partymember_xp_messages)
    window.huge_font_draw(25, window.height/9*6, 0, Color::YELLOW, "Total Party XP: #{party.sum(&:xp)}")
    window.normal_font_draw(window.width/5*3, window.height/7*6, 0, Color::YELLOW, 'Press [space] to journey again!')
  end

  def key_pressed(id)
    set_next_and_ready(MainMenu) if id == Keys::Space
  end
end
