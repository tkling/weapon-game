# Xtreme Weapon Grindfest

## what
A game I'm making by myself. Autoadvancing dungeon crawler with lots of leveling opportunities.
Item and skill leveling inspired by Disgaea. Player is rewarded for making decisions quickly 
through the use of timers in battle. 

### leveling opportunities
type | level range
-----|------------
character | 1 - 100
weapon | 1 - 50
armor | 1 - 50
skill | 1 - 50
item use | 1 - 20

### battle speed rewards
Each decision has a base of 1 second. Decide within `x` seconds to:

x (sec) | effect
--------|-------
.25 (best)    | + 10% crit chance, + 25% exp if enemy dies
.5 (great)    | + 5% crit change, + 10% exp if enemy dies

Decisions can have subdecisions that reset the timer. Examples: 
- battle menu -> item menu -> item and target selected
- battle menu -> skill menu -> skill and target selected

## motivation
Creator of Stardew Valley, ConcernedApe. Think of what he did - he put in hard work for 4 or 5 
years of his life, and now he has created an incredibly well done game which he loves. He's his
own boss, creates his own schedule, works wherever and however he wants to, and with whoever he
wants to. 

That is what I am going to do.

## how
### Gosu with Ruby
Right now I'm modeling this using Gosu and Ruby. I think I want to continue exploring this in 
Ruby as I feel like it will afford me better automated testing opportunities of the core game
mechanics. The overall logic and battle implementation can be explored without painting to the 
screen, and by doing this I can test how long leveling takes in different encounter scenarios
and with different preset levels for any level-able feature.

### Yoyo Games Gamemaker: Studio
Moving foward, for easy sprite and animation
support, I am going to try using Gamemaker Studio by Yoyo Games. `v1.4` is free for Window-only
exporting, $150 to also export to OSX and Linux. `v2.0` (still beta?) is $99 for Windows, OSX, 
and Linux exporting. The updated UI looks nice, and there is a free trial version that limits
your resouce count and only allows exporting to Windows.

## state ideas
main menu
- new game
- continue
- saves (management?)
- options
- close

new game
- create save file
- set starting state
- start game

continue
- load saved game state
- start game

saves
- show list of saves
- c to copy save
- x to delete save

start game (dungeon select)
- show journey status/map
- select dungeon
- m opens menu

in-game menu
- character status
- equip
- weapon stuff
- save

main gameplay aka journeying
- select dungeon
- dungeon loop
  - choose path
  - move on path
  - enemy wave battle
  - random loot drop?
  
## achievement ideas
- train a partymember to level 25
- train a partymember to level 50
- train a partymember to level 75
- train a partymember to level 100
- train entire party to level 100
- train a weapon skill to 25
- train a weapon skill to 50
- train an item proficiency to 10
- train an item proficiency to 20
- grind a weapon to level 25
- grind a weapon to level 50
- grind an armor to level 25
- grind an armor to level 50
- achievement for each class hitting level 99 
  
## example as-a-state-machine code
```ruby
require 'gosu'
require 'aasm'

class Gamewindow < Gosu::Window
  include AASM
  
  aasm do
    state :welcome_screen, initial: true
    state :main_menu
    state :new_game_creation
    state :continue_saved_game
    state :manage_saves
    state :start_game_dungeon_select
    state :journey_loop
    state :in_game_menu
    event :main_menu_open do
      transitions from: :welcome_screen, to: :main_menu
    end
  end
end
    
```

