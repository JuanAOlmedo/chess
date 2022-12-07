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

    def initialize
        @current_color = :white
    end

    def play
        until win
            board.display

            puts "#{current_color.capitalize} turn"
            loop do
                position = ask_position

                board.display highlight: position.piece.possible

                position2 = ask_position2

                moved, reason = board.move current_color, position, position2
                break if moved

                board.show
                puts "Incorrect input: #{reason}"
                puts 'Please choose again'
            end

            @current_color = current_color == :white ? :black : :white
            save_to_file 'autosave'
        end

        puts "#{board.white_king ? 'White' : 'Black'} wins!!"
    end

    def win
        !board.white_king || !board.black_king
    end

    def save
        { board: board.save, color: current_color }
    end

    def save_to_file(filename)
        File.open(filename, 'w') do |file|
            file.write save.to_msgpack
        end
    end

    def self.load(game)
        g = Game.new
        g.board = Board.load game['board']
        g.current_color = game['color'].to_sym

        g unless g.win
    end

    def self.load_from_file(filename)
        File.open(filename, 'r') do |file|
            self.load MessagePack.load(file.read)
        end
    rescue StandardError
        false
    end

    private

    def ask_position
        print 'Select: '
        loop do
            position = board.find human_to_position(gets.chomp.split(':'))

            break position if position.piece.color == current_color

            puts 'Not your piece!'
        rescue StandardError
            puts 'Invalid input'
        end
    end

    def ask_position2
        print 'Move: '
        loop do
            break board.find human_to_position(gets.chomp.split(':'))
        rescue StandardError
            puts 'Invalid input'
        end
    end

    # Transform the position shown to the player to the positions used internally
    def human_to_position(human)
        alphabet = %w[A B C D E F G H]

        human[0] = alphabet.index human[0].upcase
        human[1] = 8 - human[1].to_i

        human
    end
end

puts '----- CHESS ------'
puts 'Syntax:    A:2 e:8'
puts ''

game = Game.load_from_file('autosave') || Game.load_from_file('empty_board')

game.play
