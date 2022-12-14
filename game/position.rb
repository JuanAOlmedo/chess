# frozen_string_literal: true

require './game/vector'

# A position in the board with an x and y coordinate
class Position
    include Vector
    attr_accessor :x, :y, :board, :piece

    def initialize(x, y, board, piece: nil)
        @x = x
        @y = y
        @board = board
        @piece = piece
    end

    def change_piece(piece)
        @piece = piece
        @piece.position = self
    end

    def in_range?(piece)
        piece.possible.include? to_a
    end

    def empty?
        piece.is_a? Empty
    end

    def save
        [x, y, piece.save]
    end

    def self.load(array, board)
        position = Position.new(array[0], array[1], board, piece: Empty.new)
        position.change_piece Piece.load(array[2], board) unless array[2][0] == 'Empty'
        position
    end

    def inspect
        "X: #{x}, Y: #{y}, #{piece.inspect}"
    end
end
