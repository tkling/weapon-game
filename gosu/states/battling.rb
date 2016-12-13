class Battling < GameState
  INTERNAL_STATES = %i(collecting_party_commands selecting_target)

  def initialize(window)
    super window
    @current_partymember_idx = 0
    @commands = Hash.new
    @target_map = make_target_map
    @damages = []
    @internal_state = :collecting_party_commands
  end

  def make_target_map
    target_keys = [Gosu::KbQ, Gosu::KbW, Gosu::KbE, Gosu::KbR]
    mapping = Hash.new
    current_enemies.each_with_index do |enemy, idx|
      mapping[target_keys[idx]] = enemy
    end
    mapping
  end

  def current_partymember
    party[@current_partymember_idx]
  end

  def update
    if @commands.count == 3 && @commands.map { |c| c[:target] }.size == 3
      # we have full party input, resolve damage
      @commands.each do |partymember, skill_info|
        from = partymember
        to = skill_info[:target]
        source = skill_info[:skill]
        damage = Damage.new(from: from, to: to, source: source)
        @damages << damage
        to.damage << damage
      end

      @showing_damage_resolution = true
      @awaiting_confirmation = true
      @current_partymember_idx = 0
      @commands = []
    end

    if current_enemies.map { |ene| ene.current_hp }.reduce(:+) == 0
      set_next_and_ready Victory.new(@window, ['good_loot'])
    end
  end

  def draw
    banner = 'B A T T L E'
    @window.huge_font_draw(25, 15, 0, Color::YELLOW, banner)

    if @commands.count < 3
      enter_command = if @commands.dig(current_partymember, :skill) #@commands[current_partymember][:skill]
                        "Select target for #{ current_partymember.name }'s #{ @commands[current_partymember][:skill] }"
                      else
                        "Select skill for #{ current_partymember.name }"
                      end
      @window.large_font_draw(25, 100, 0, Color::YELLOW, enter_command)

      # player list

      # enemy list

    end
  end

  def key_pressed(id)
    if @commands.size < 3 && !@awaiting_confirmation
      case id
      when Gosu::KbQ, Gosu::KbW, Gosu::KbE, Gosu::KbR
        if @commands[current_partymember] == nil
          @commands[current_partymember] = { skill: @command_options[current_partymember][id] }
        else
          @commands[current_partymember][:target] = @target_map[id]
          @current_partymember_idx += 1
        end
      else
        raise 'invalid input for partymember input!'
      end
    end

    if @awaiting_confirmation
      if id == Gosu::KbSpace
        @showing_damage_resolution = false if @showing_damage_resolution
        @awaiting_confirmation = false
      end
    end
  end
end
