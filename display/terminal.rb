# frozen_string_literal: true

require 'colorize'

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
