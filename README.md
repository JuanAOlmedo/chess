# chess.rb
![Screenshot from 2022-12-22 20-01-10](https://user-images.githubusercontent.com/64656937/209239501-d310d8c4-9773-440c-bce7-e031eea36688.png)


Chess written in ruby.

It currently has all basic features except for [pawn promotion](https://en.wikipedia.org/wiki/Promotion_(chess)). The game 
can be displayed inside a curses window, which gets dinamically refreshed or can be played in a 'basic' mode with the `--cli` flag

It gets automatically saved for each move you make to a file named autosave. This file will be loaded each time you start
the game by default. To override this, run with the `--new` or `-n` flag
