# frozen_string_literal: true

require 'msgpack'
Dir['./game/*.rb'].each { |file| require file }
Dir['./game/pieces/*.rb'].each { |file| require file }

# Controlls turns, when the game has been won, what to do on each situation
class Game
    attr_accessor :board, :display, :current_color

    def initialize(display)
        @display = display
        @current_color = :white
    end

    # Main method, whith which the game is started
    def play
        until win
            display.board board.board, "#{current_color.capitalize} turn\n"

            loop do
                position = display.ask_position('Select: ', 'Not your piece!') do |p|
                    p = board.find human_to_position(p)
                    p.piece.color == current_color ? p : nil
                end

                display.highlighted board, position.piece.possible

                position2 = display.ask_position('Move: ', 'Invalid position') do |p|
                    board.find human_to_position(p)
                end

                break if board.move current_color, position, position2

                display.board board.board, "Invalid movement\nPlease choose\nagain"
            end

            @current_color = current_color == :white ? :black : :white
            save_to_file 'autosave'
        end

        display.win board.white_king ? 'White' : 'Black'
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

    def self.load(hash, window)
        game = Game.new(window)
        game.board = Board.load hash['board']
        game.current_color = hash['color'].to_sym

        game unless game.win
    end

    def self.load_from_file(filename, window)
        File.open(filename, 'r') { |f| self.load MessagePack.load(f.read), window }
    rescue StandardError
        false
    end

    private

    # Transform the position shown to the player to the positions used internally
    def human_to_position(human)
        [%w[A B C D E F G H].index(human[0].upcase), 8 - human[1].to_i]
    end
end
