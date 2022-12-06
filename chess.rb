# frozen_string_literal: true

require 'colorize'
require 'msgpack'
require './board'
require './empty'
require './movement_map'
require './movement'
require './path'
require './pieces'
require './position'
class Game
    attr_accessor :board, :current_color

    def initialize(skip_board: false)
        @board = Board.new unless skip_board
        @current_color = :white
    end

    def play
        until win
            board.show

            puts "#{current_color.capitalize} turn"
            loop do
                position = ask_position

                board.show_possible current_color, position

                position2 = loop do
                    break board.find human_to_position(gets.chomp.split(':'))
                rescue StandardError
                    puts 'Invalid input'
                end

                moved, reason = board.move current_color, position, position2
                break if moved

                board.show
                puts "Incorrect input: #{reason}"
                puts 'Please choose again'
            end

            @current_color = current_color == :white ? :black : :white
            save_to_file
        end

        show_win_message
    end

    def win
        !board.white_king || !board.black_king
    end

    def human_to_position(human)
        alphabet = %w[A B C D E F G H]

        human[0] = alphabet.index human[0].upcase
        human[1] = 8 - human[1].to_i

        human
    end

    def save
        { board: board.save, color: current_color }
    end

    def save_to_file
        File.open('data', 'w') do |file|
            file.write save.to_msgpack
        end
    end

    def self.load(game)
        g = Game.new skip_board: true
        g.board = Board.load game['board']
        g.current_color = game['color'].to_sym

        g
    end

    def self.load_from_file
        File.open('data', 'r') do |file|
            self.load MessagePack.load(file.read)
        end
    end

    def self.safe_load_from_file
        game = load_from_file
        return game unless game.win
    rescue StandardError
        false
    end

    private

    def ask_position
        loop do
            position = board.find human_to_position(gets.chomp.split(':'))

            break position if board.selectable_position? position, current_color

            puts 'Not your piece!'
        rescue StandardError
            puts 'Invalid input'
        end
    end

    def show_win_message
        puts "#{board.white_king ? 'White' : 'Black'} wins!!"
    end
end

puts '----- CHESS ------'
puts 'Syntax:'
puts 'From     To:'
puts 'A:1      B:2'
puts 'Example: A:1 B:2'
puts ''

game = Game.load_from_file || Game.new

game.play
