class MapCompleted < GameState
  def draw
    window.huge_font_draw(10, 10, 0, 'J O U R N E Y C O M P L E T E !')
    window.large_font_draw(100, 160, 0, 'Final XP amounts:')

    partymember_xp_messages = party.map do |partymember|
      "#{partymember.name}: Level #{partymember.level}, total XP: #{partymember.xp}"
    end

    window.large_font_draw(window.width/2-200, window.height/4+50, 35, *partymember_xp_messages)
    window.huge_font_draw(25, window.height/9*6, 0, "Total Party XP: #{party.sum(&:xp)}")
    window.normal_font_draw(window.width/5*3, window.height/7*6, 0, 'Press [space] to journey again!')
  end

  def bind_keys
    bind Keys::Space, ->{ proceed_to MainMenu }
  end
end
