# frozen_string_literal: true

class Position
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

    def empty?
        piece.is_a? Empty
    end

    def to_a
        [x, y]
    end

    def save
        [x, y, piece.save]
    end

    def self.load(position, board)
        Position.new(position[0], position[1], board).change_piece Piece.load(position[2])

    end

    def inspect
        "X: #{x}, Y: #{y}, #{piece.inspect}"
    end
end
