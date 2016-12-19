# Some thoughts about Battling

## internal states
* battle begin (determine and show battle order)
  * ```ruby
    if @battle_order.first.class == Partymember
      set_next_and_ready SkillTargetSelect(@window, @battle_order)
    else
      set_next_and_ready EnemyTurn.new(@window, @battle_order)
    end
    ```
* hero turn
  * select skill or item list
  * if skill -> select target
  * if item list -> select item -> select target
  * resolve selected action
* enemy turn
  * select offensive skill if current_hp/max_hp > .4
  * else select healing skill. if no healing skill, use heal item
  * if no heal item and has a defensive skill, use that
  * otherwise attack
* if all enemies health at 0 show 'VICTORY' for a couple seconds
* transition to victory screen
  * show map, dungeon, encounter progress 
  * show xp earned with breakdown
  * items gained
* if dungeon encounter index+1 == encounters.size
  * transition to dungeon boss
  * else
  * transition to caravan map, increment dungeon encounter index  
