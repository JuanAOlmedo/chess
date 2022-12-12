# frozen_string_literal: true

require 'colorize'

# Used by the Game class to display the board, ask the user for input and other tasks
# related to communicating with the user
# 
# Does essentially the same as curses.rb, but it displays everything with 'puts' instead
# of creating a Curses window, which makes it easier to debug the core components
class TerminalDisplay
    def board(board, message)
        puts board, message
    end

    def highlighted(board, highlight)
        puts board.board_highlighted highlight
    end

    def ask_position(prompt, error_mesage)
        loop do
            print prompt

            position = yield($stdin.gets.chomp.split(''))
            break position if position

            puts error_mesage
        rescue StandardError
            puts 'Invalid input'
        end
    end

    def win(winner)
        puts "#{winner} wins!!"
    end
end
