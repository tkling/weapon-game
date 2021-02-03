# frozen_string_literal: true
class MainMenu < GameState
  include SaveMethods

  def initialize(game_window)
    super
    @choice_list = SelectableChoiceList.new(
      draw_method: :large_font_draw,
      starting_index: savefile_paths.any? ? 1 : 0,
      choice_mappings: [
        { text: 'new game', action: ->{ proceed_to NewGame } },
        { text: 'continue', action: ->{ proceed_to Continue } },
        { text: 'options',  action: ->{ proceed_to Options } },
        { text: 'quit',     action: ->{ window.close } }
      ]
    )
  end

  def draw
    window.huge_font_draw(45, 20, 0, Color::YELLOW, 'WEAPON GAME MAIN MENU')
    @choice_list.draw(x: 320, y_start: 200, y_spacing: 40)
  end
end
