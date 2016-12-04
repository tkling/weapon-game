require 'gosu'

module ZOrder
  UI = 1
end

module Color
  YELLOW = 0xff_ffff00
end

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    @state = Hash(commands: [])
    @skill_map = sample_skill_mapping
    @battle_texts = []
    @allowed_to_proceed = false
    @font = Gosu::Font.new(20)
    self.caption = 'Future Weapon Game Xtreme'
  end

  def update
    set_prompt_text
    resolve_battle_commands if in_battle? && commands.size == 3
    proceed
  rescue Exception, StandardError => err
    @state[:error] = err
    require 'pry'; binding.pry
  end

  def draw
    @font.draw(@text, 10, 10, ZOrder::UI, 1.0, 1.0, Color::YELLOW)

    if @battle_texts.size == 3
      start_y = 10
      @battle_texts.size.times do
        @font.draw(@battle_texts.pop, 10, start_y += 25, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
      end
      @font.draw('Press [return] to continue', 10, start_y += 25, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
    end
  end

  def set_prompt_text
    text_start = 'enter 3 from [q, w, e, d]'
    @text = case commands.size
            when 3
              "executing commands: #{ commands }"
            when (1..2)
              text_start + " | commands.size: #{ commands.size } & commands: #{ commands }"
            else
              text_start
            end
  end

  def in_battle?
    true
  end

  def proceed
    if @allowed_to_proceed
      @state[:commands] = []
      @allowed_to_proceed = false
    end
  end

  def resolve_battle_commands
    @battle_texts = commands.map do |key|
      "Performing #{ @skill_map[key][:name] } for #{ @skill_map[key][:damage] } damage!"
    end
  end

  def sample_skill_mapping
    {
      q: { name: 'Arc Slash',       damage: 25 },
      w: { name: 'Shield Smack',    damage: 12 },
      e: { name: 'Crossbow Cowboy', damage: 17 },
      d: { name: 'Unholy Stink',    damage: 3 }
    }
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    when Gosu::KbQ
      commands << :q
    when Gosu::KbW
      commands << :w
    when Gosu::KbE
      commands << :e
    when Gosu::KbD
      commands << :d
    when Gosu::KbReturn
      @allowed_to_proceed = true
    end
  end

  def commands
    @state[:commands]
  end
end

window = GameWindow.new
window.show
