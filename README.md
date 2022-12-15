# chess.rb

Chess written in ruby.

It currently has all basic features except for [pawn promotion](https://en.wikipedia.org/wiki/Promotion_(chess)). The game 
can be displayed inside a curses window, which gets dinamically refreshed or can be played in a 'basic' mode with the `--cli` flag

It gets automatically saved for each move you make to a file named autosave. This file will be loaded each time you start
the game by default. To override this, run with the `--new` or `-n` flag
