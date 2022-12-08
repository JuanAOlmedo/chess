# frozen_string_literal: true

require 'curses'
require 'msgpack'
require './vector'
require './board'
require './empty'
require './movement_map'
require './movement'
require './path'
require './pieces'
require './position'

class Game
    attr_accessor :board, :window, :current_color
    def initialize(window)
        @window = window
        @current_color = :white
    end

    def play
        until win
            window.clear
            window.addstr board.board
            window.addstr "#{current_color.capitalize} turn\n"

            loop do
                position = ask_position

                highlight position.piece.possible

                position2 = ask_position2

                break if board.move current_color, position, position2

                window.clear
                window.addstr board.board
                window.addstr "Invalid movement\nPlease choose\nagain"
            end

            @current_color = current_color == :white ? :black : :white
            save_to_file 'autosave'
        end

        Curses.close_screen

        puts "#{board.white_king ? 'White' : 'Black'} wins!!"
    end

    def win
        !board.white_king || !board.black_king
    end

    def save
        { board: board.save, color: current_color }
    end

    def save_to_file(filename)
        File.open(filename, 'w') { |f| f.write save.to_msgpack }
    end

    def self.load(game, window)
        g = Game.new(window)
        g.board = Board.load game['board']
        g.current_color = game['color'].to_sym

        g unless g.win
    end

    def self.load_from_file(filename, window)
        File.open(filename, 'r') { |f| self.load MessagePack.load(f.read), window }
    end

    private

    def highlight(highlight)
        window.attrset Curses::A_BLINK

        highlight.each do |to_highlight|
            window.setpos(9 - to_highlight[1], to_highlight[0] * 2 + 2)
            window.addstr board.find(to_highlight).piece.show_highlighted
        end

        window.attrset Curses::A_NORMAL
    end

    def ask_position
        window.setpos(13, 0)
        loop do
            window.deleteln
            window.addstr 'Select: '

            position = board.find human_to_position(get_input.split(':'))

            break position if position.piece.color == current_color

            window.setpos(13, 0)
            window.addstr "Not your piece!\n"
        rescue StandardError
            window.setpos(13, 0)
            window.addstr "Invalid input\n"
        end
    end

    def ask_position2
        window.setpos(13, 0)
        loop do
            window.deleteln
            window.addstr 'Move: '

            break board.find human_to_position(get_input.split(':'))

            window.setpos(13, 0)
        rescue StandardError
            window.setpos(13, 0)
            window.addstr "Invalid input\n"
        end
    end

    def get_input
        x, y = window.curx, window.cury
        input = []

        while ch = window.get_char
            case ch
            when "\n"
                break
            when "\u007F"
                next unless input.pop
                window.setpos(y, window.curx - 1)
                window.delch
            else
                input << ch
                window.addch ch
            end
        end

        input.join ''
    end

    # Transform the position shown to the player to the positions used internally
    def human_to_position(human)
        alphabet = %w[A B C D E F G H]

        [alphabet.index(human[0].upcase), 8 - human[1].to_i]
    end
end

Curses.init_screen
Curses.cbreak
Curses.noecho
Curses.stdscr.keypad = true

width = 18
left = (Curses.cols - width) / 2

window = Curses::Window.new(0, 0, 0, 0)

chess = window.subwin 0, width, 0, left
chess.addstr "----- CHESS ------\nSyntax:    A:2 e:8\n"

game_win = window.subwin(0, width, 5, left)

game = Game.load_from_file('autosave', game_win) || Game.load_from_file('empty_board', game_win)
game.play

