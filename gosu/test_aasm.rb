require 'gosu'
require 'aasm'

require './constants'
require './models'

class GameWindow < Gosu::Window
  include AASM, SpawningMethods

  aasm whiny_transitions: false do
    state :show_parties, initial: true
    state :collect_battle_commands
    state :resolve_battle_commands
    state :end_battle
    state :next_battle

    event :begin_battle do
      transitions from: :show_parties,
                  to: :collect_battle_commands
    end

    event :collecting_commands do
      transitions from: [:collect_battle_commands, :resolve_battle_commands],
                  to: :collect_battle_commands,
                  guard: -> { commands.size < 3 }
    end

    event :resolving_commands do
      transitions from: :collect_battle_commands,
                  to: :resolve_battle_commands,
                  guard: -> { commands.size == 3},
                  after: -> { construct_battle_texts }
    end

    event :ending_battle do
      transitions from: :resolve_battle_commands,
                  to: :end_battle,
                  guard: -> { enemies.map { |ene| ene.base_stats[:hp] > 0 }.size == 0 },
                  after: -> { grant_rewards }
    end
  end

  def initialize
    super 800, 600
    @state = Hash(commands: [])
    @skill_map = sample_skill_mapping
    @battle_texts = []
    @accepting_input = true
    @party = spawn_characters(3)
    @enemies = spawn_enemies(2)
    @target_map = setup_target_map
    @large_font = Gosu::Font.new(30)
    @normal_font = Gosu::Font.new(20)
    @small_font = Gosu::Font.new(15)
    self.caption = 'Future Weapon Game Xtreme'
  end

  def update
    if in_battle?
      self.collecting_commands if commands.size < 3
      self.resolving_commands  if commands.size == 3
      assign_battle_damage # ????
      self.ending_battle if @enemies.map { |ene| ene.base_stats[:hp] > 0 }.size == 0
    end
  rescue Exception, StandardError => err
    open_repl err
  end

  def draw
    draw_state_info
    draw_screen
  rescue Exception, StandardError => err
    open_repl(err)
  end

  def setup_target_map
    map = {}
    target_keys = %i(q w e d)
    @enemies.each_with_index { |ene, idx| map[ene.name] = target_keys[idx] }
    map
  end

  def assign_battle_damage

  end

  def draw_state_info
    state_info = "current state: #{ aasm.current_state }"
    @small_font.draw(state_info, 10, 560, ZOrder::UI, 1.0, 1.0, Color::YELLOW)

    transition_info = "from #{ aasm.from_state } to #{ aasm.to_state } (event: #{ aasm.current_event })"
    @small_font.draw(transition_info, 10, 580, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
  end

  def draw_screen
    case aasm.current_state
    when :show_parties
      draw_continue 10
      draw_party_info 10
      draw_enemy_info 10
    when :collect_battle_commands
      @accepting_input = true
      draw_battle_prompt
    when :resolve_battle_commands
      draw_command_resolution
    when :end_battle
      draw_rewards_screen
    else
      open_repl RuntimeError.new 'weird state'
    end
  end

  def draw_continue(y_start)
    @large_font.draw('Press [return] to continue', 10, y_start, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
  end

  def draw_party_info(y_start)
    y_start += 5
    x = 10
    @party.each do |char|
      info = "#{ char.name }\tHP:#{ char.base_stats[:hp] }"
      @normal_font.draw(info, x, y_start += 25, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
    end
  end

  def draw_enemy_info(y_start)
    y_start += 5
    x = 400
    @enemies.each do |char|
      info = "#{ char.name }\tHP:#{ char.base_stats[:hp] }"
      @normal_font.draw(info, x, y_start += 25, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
    end
  end

  def draw_battle_prompt
    text_start = 'enter 3 from [q, w, e, d]'
    @text = case commands.size
            when (1..2)
              text_start + " | commands.size: #{ commands.size } | commands: #{ commands }"
            else
              text_start
            end
    @normal_font.draw(@text, 10, 10, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
  end

  def draw_command_resolution
    @accepting_input = false
    @normal_font.draw("executing commands: #{ commands }", 10, 10, ZOrder::UI, 1.0, 1.0, Color::YELLOW)

    start_y = 10
    @battle_texts.each do |text|
      @normal_font.draw(text, 10, start_y += 25, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
    end
    @normal_font.draw('Press [return] to continue', 10, start_y += 25, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
  end

  def draw_battle_end
    @normal_font.draw('The battle is over!', 10, 10, ZOrder::UI, 1.0, 1.0, Color::YELLOW)
  end

  def construct_battle_texts
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

  def open_repl(err)
    require 'pry'; binding.pry
  end

  def commands
    @state[:commands]
  end

  def proceed_battle
    if in_battle? && aasm.current_state == :resolve_battle_commands
      @state[:commands] = []
      @battle_texts = []
      self.collecting_commands
    end
  end

  def proceed_prebattle
    @state[:commands] = []
    self.begin_battle
  end

  def in_battle?
    ![:show_parties, :end_battle].include?(aasm.current_state)
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    when Gosu::KbF
      open_repl RuntimeError.new 'pressed f'
    when Gosu::KbQ
      commands << :q if @accepting_input
    when Gosu::KbW
      commands << :w if @accepting_input
    when Gosu::KbE
      commands << :e if @accepting_input
    when Gosu::KbD
      commands << :d if @accepting_input
    when Gosu::KbReturn
      in_battle? ? proceed_battle : proceed_prebattle
    end
  end
end

window = GameWindow.new
window.show
