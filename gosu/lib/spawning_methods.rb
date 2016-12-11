module SpawningMethods
  def job_types
    @job_types ||= %i(fencer rogue mage cleric)
  end

  def weapon_types
    @weapon_types ||= %i(longsword spear dagger staff)
  end

  def random_weapon
    @adjectives ||= %w(Brave Humiliating Embarassing All-Encompassing Shy Tasty Distasteful)
    @nouns ||= %w(Whipper-Snapper Slicer Maul Axe Bomba Chopsticks)

    adj = @adjectives.sample
    @adjectives.delete adj

    noun = @nouns.sample
    @nouns.delete noun

    name = "#{ adj } #{ noun }"
    low_damage = random_from_range(1..10)
    high_damage = random_from_range(8..25)
    skill = Skill.new(name: 'Strike', element: 'Neutral', base_stats: { str: 13 })
    Weapon.new(name: name, type: weapon_types.sample, skills: [skill],
               base_stats: { damage_range: (low_damage..high_damage) })
  end

  def random_armor
    Armor.new(name: 'Basic Armor', damage_resist: 5)
  end

  def spawn_characters(count)
    count.times.map do |idx|
      Character.new(name: "Hero#{ idx }", job: job_types[idx],
                    weapon: random_weapon, armor: random_armor, type: :partymember, items: [],
                    base_stats: { hp: random_from_range(14..30) })
    end
  end

  def spawn_enemies(count)
    count.times.map do |idx|
      Character.new(name: "Enemy#{ idx }", job: job_types[idx],
                    weapon: random_weapon, armor: random_armor, type: :enemy, items: [],
                    base_stats: { hp: random_from_range(10..27) })
    end
  end

  def spawn_starting_hero(job)
    @names ||= %w(Sherryl Marle Taylor Rihanna Kevin Eric Seb Devon Einstein Bastion Clarence Hannah Mertle Xena)
    items = [:potion, :potion, :grenade, :cheese_wheel]
    Character.new(name: @names.sample, job: job, weapon: random_weapon, armor: random_armor,
                  type: :partymember, items: items, base_stats: { hp: random_from_range(14..30) })
  end

  def random_from_range(range)
    range.to_a.sample
  end

  def generate_dungeons(amount)
    @dungeon_adjectives = %w(Forbidden Forboding Foggy Froggy Questionable Sketchy Nefarious
                               Disgusting Dank Soggy Unstable )
    @dungeon_nouns = %w(Tarn Steppe Tunnel Escape Path Bog Swamp Dunes Village)
    @encounter_range ||= (2..10).to_a
    amount.times.map do
      adj = @dungeon_adjectives.sample
      noun = @dungeon_nouns.sample
      @dungeon_adjectives.delete adj
      @dungeon_nouns.delete noun
      Dungeon.new(name: "#{ adj} #{ noun }", encounter_count: @encounter_range.sample)
    end
  end
end
