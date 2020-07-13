# `W E A P O N G A M E`

## what
This is the modeled, text-only (for now? or permanently?) version of the game. It's implemented
in `ruby` using the game dev gem `gosu`. `gosu` provides a 60 fps game loop with draw and update
hooks; the screen is painted manually using images and fonts.

I am thinking right now that the ruby version of the game will be useful for modeling/balancing
later in this process. I can drive automated tests of the game logic and stat values for objects
as they finish encounters and level up.

## install and usage
```bash
# get `gosu` and some other gems
bundle install

# run the first stab at all of this
# early battle ideas
ruby ./test.rb

# battle ideas, very similar to the first, but using gem `aasm` for state changes
ruby ./test_aasm.rb

# welcome screen, new/continue game, persisting with save file
# uses handmade non-validated state classes
# this is the 'current build'
ruby ./artisinal_handmade_states.rb
```

#### works on windows
Install Git for Windows as well as the RubyInstaller packaged version of ruby.
Even `pry` works in `powershell`!

#### works on linux
Gosu has system dependencies that will need to be installed so that it can install and build: 
https://github.com/gosu/gosu/wiki/Getting-Started-on-Linux#dependencies
