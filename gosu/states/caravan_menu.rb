class CaravanMenu < GameState
  def bind_keys
    @choice_list = SelectableChoiceList.new(
      draw_method: :large_font_draw,
      choice_mappings: [
        { text: 'Battle',    action: ->{ proceed_to BattleIntro } },
        { text: 'Status',    action: ->{ proceed_to Status } },
        { text: 'Inventory', action: ->{ proceed_to Inventory } },
        { text: 'Config',    action: ->{ proceed_to PartyConfig } },
        { text: 'Save',      action: ->{ proceed_to Save } },
        { text: 'Quit',      action: ->{ window.close } }
      ]
    )
  end

  def draw
    x_left = 25
    window.huge_font_draw(x_left, 15, 0, Color::YELLOW, 'C A R A V A N_M E N U')

    window.large_font_draw(x_left, 200, 30, Color::YELLOW,
      "Map: #{ map.name }",
      "Dungeon: #{ dungeon.name }",
      "Encounter: #{ dungeon.encounter_index+1 }/#{ dungeon.encounters.size }"
    )

    window.large_font_draw(x_left, window.height-200, 30, Color::YELLOW,
      'Time played:',
      formatted_time_played
    )

    @choice_list.draw(x: window.width-200, y_start: 150, y_spacing: 40)
  end
end

