module SpawningMethods
  def job_types
    @job_types ||= %i(knight rogue priest)
  end

  def weapon_types
    @weapon_types ||= %i(longsword spear dagger staff)
  end

  def random_weapon
    @adjectives ||= %w(Brave Humiliating Embarassing All-Encompassing Shy Tasty Distasteful)
    @nouns ||= %w(Whipper-Snapper Slicer Maul Axe Bomba Chopsticks)

    adj = @adjectives.delete(@adjectives.sample)
    noun = @nouns.delete(@nouns.sample)
    name = "#{ adj } #{ noun }"
    skill = Skill.from_castle_id(Skill.all_castle_ids.sample)
    Weapon.new(name: name, type: weapon_types.sample, skills: [skill],
               base_stats: { damage_range: (rand(1..10)..rand(8..25)) })
  end

  def random_armor
    Armor.from_castle_id(Armor.all_castle_ids.sample)
  end

  def make_encounters(count)
    count.times.map do |_|
      spawn_enemies rand(1..3)
    end
  end

  def spawn_enemies(count)
    count.times.map do |idx|
      hp = rand(10..27)
      Character.new(name: "Enemy#{ idx }", job: job_types[idx],
                    weapon: random_weapon, armor: random_armor, type: 'enemy',
                    current_hp: hp, base_stats: { hp: hp, dex: rand(2..9) })
    end
  end

  def spawn_starting_hero(job)
    @names ||= %w(Sherryl Marle Taylor Rihanna Kevin Eric Seb Devon Einstein Bastion Clarence Hannah Mertle Xena Dante
                  Derek Delilah Devin Darcy Gwen Cerise Eleanor Heidi Tyler Quan Marr Tan Kanav Jackie Jack James Alec)
    hp = rand(14..30)
    Character.new(name: @names.sample, job: job, weapon: random_weapon, armor: random_armor,
                  type: 'partymember', current_hp: hp, base_stats: job_base_stats(job).merge({hp: hp}))
  end

  def job_base_stats(job)
    case job
    when :knight then { str: 13, dex: 3, int: 4 }
    when :rogue  then { str: 7,  dex: 8, int: 5 }
    when :priest then { str: 3,  dex: 4, int: 13 }
    else raise 'unknown job type!'
    end
  end

  def generate_dungeons(amount)
    @dungeon_adjectives = %w(Forbidden Forboding Foggy Froggy Questionable Sketchy Nefarious Disgusting Dank Soggy
                             Unstable Bright Fetid Humid Windswept Abandoned Mossy Moist Parched Manicured)
    @dungeon_nouns = %w(Tarn Steppe Tunnel Escape Path Bog Swamp Dunes Village Beach Desert Path Alley Nook Palace)
    amount.times.map do
      adj = @dungeon_adjectives.delete(@dungeon_adjectives.sample)
      noun = @dungeon_nouns.delete(@dungeon_nouns.sample)
      Dungeon.new(name: "#{ adj } #{ noun }", encounters: make_encounters(rand(2..12)))
    end
  end
end
