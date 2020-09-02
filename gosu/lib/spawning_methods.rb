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

    adj = @adjectives.sample.tap { |adj| @adjectives.delete(adj) }
    noun = @nouns.sample.tap { |n| @nouns.delete(n) }
    name = "#{ adj } #{ noun }"
    skill = Skill.from_castle_id(Skill.all_castle_ids.sample)
    Weapon.new(name: name, type: weapon_types.sample, skills: [skill],
               base_stats: { damage_range: (random_from_range(1..10)..random_from_range(8..25)) })
  end

  def random_armor
    Armor.new(name: 'Basic Armor', damage_resist: 5)
  end

  def make_encounters(count)
    count.times.map do |_|
      spawn_enemies random_from_range(1..3)
    end
  end

  def spawn_enemies(count)
    count.times.map do |idx|
      hp = random_from_range(10..27)
      Character.new(name: "Enemy#{ idx }", job: job_types[idx],
                    weapon: random_weapon, armor: random_armor, type: 'enemy',
                    current_hp: hp, base_stats: { hp: hp })
    end
  end

  def spawn_starting_hero(job)
    @names ||= %w(Sherryl Marle Taylor Rihanna Kevin Eric Seb Devon Einstein Bastion Clarence Hannah Mertle Xena)
    hp = random_from_range(14..30)
    Character.new(name: @names.sample, job: job, weapon: random_weapon, armor: random_armor,
                  type: 'partymember', current_hp: hp, base_stats: { hp: hp })
  end

  def random_from_range(range)
    range.to_a.sample
  end

  def generate_dungeons(amount)
    @dungeon_adjectives = %w(Forbidden Forboding Foggy Froggy Questionable Sketchy Nefarious
                               Disgusting Dank Soggy Unstable)
    @dungeon_nouns = %w(Tarn Steppe Tunnel Escape Path Bog Swamp Dunes Village)
    @encounter_range ||= (2..10).to_a
    amount.times.map do
      adj = @dungeon_adjectives.sample.tap { |a| @dungeon_adjectives.delete(a) }
      noun = @dungeon_nouns.sample.tap { |n| @dungeon_nouns.delete(n) }
      Dungeon.new(name: "#{ adj } #{ noun }", encounters: make_encounters(random_from_range(2..12)))
    end
  end
end
