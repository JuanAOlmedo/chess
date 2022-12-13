# frozen_string_literal: true

require 'curses'

# Used by the Game class to display the board, ask the user for input and other tasks
# related to communicating with the user
#
# Does essentially the same as terminal.rb, but displays everything inside a Curses
# window
class CursesDisplay
    attr_reader :window

    def initialize
        Curses.init_screen
        Curses.cbreak
        Curses.noecho
        Curses.stdscr.keypad = true

        width = 18
        left = (Curses.cols - width) / 2

        @main_window = Curses::Window.new(0, 0, 0, 0)

        @chess_window = @main_window.subwin 0, width, 1, left
        @chess_window.addstr '----- chess ------'
        @chess_window.refresh

        @window = @chess_window.subwin(0, width, 5, left)
    end

    def board(board, message)
        window.clear
        window.addstr board
        window.addstr message
    end

    def highlighted(board, highlight)
        window.attrset Curses::A_BLINK

        highlight.each do |to_highlight|
            window.setpos(8 - to_highlight[1], to_highlight[0] * 2 + 2)
            window.addstr board.find(to_highlight).piece.show_highlighted
        end

        window.attrset Curses::A_NORMAL
    end

    def ask_position(prompt, error_mesage)
        window.setpos(13, 0)
        loop do
            window.deleteln
            window.addstr prompt

            position = yield(input.split(''))
            break position if position

            window.setpos(13, 0)
            window.addstr "#{error_mesage}\n"
        rescue StandardError
            window.setpos(13, 0)
            window.addstr "Invalid input\n"
        end
    end

    def input
        input = []

        while (ch = window.get_char)
            case ch
            when "\n"
                break
            when "\u007F"
                next unless input.pop

                window.setpos window.cury, window.curx - 1
                window.delch
            when Curses::KEY_RESIZE
                resize
            else
                input << ch
                window.addch ch
            end
        end

        input.join ''
    end

    # Work in progress
    def resize
        left = (Curses.cols - 18) / 2

        window.move 5, left
        @chess_window.move(1, left)
        window.refresh
        @chess_window.refresh
        @main_window.redraw
    end

    def win(winner)
        Curses.close_screen
        puts "#{winner} wins!!"
    end
end
