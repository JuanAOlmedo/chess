# frozen_string_literal: true

require 'curses'
require './game'

Curses.init_screen
Curses.cbreak
Curses.noecho
Curses.stdscr.keypad = true

width = 18
left = (Curses.cols - width) / 2

window = Curses::Window.new(0, 0, 0, 0)

chess = window.subwin 0, width, 1, left
chess.addstr "----- CHESS ------\nSyntax:    A:2 e:8\n"
chess.refresh

game_win = chess.subwin(0, width, 5, left)

game = Game.load_from_file('autosave', game_win) || Game.load_from_file('empty_board', game_win)
game.play
