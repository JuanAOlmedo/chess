# frozen_string_literal: true

class Piece
    attr_accessor :position
    attr_reader :movement_map, :color

    def save
        [self.class.name, color]
    end

    def self.load(piece)
        c = case piece[0]
            when 'Queen'
                Queen
            when 'King'
                King
            when 'Rook'
                Rook
            when 'Bishop'
                Bishop
            when 'Knight'
                Knight
            when 'Pawn'
                Pawn
            when 'UnmovedPawn'
                UnmovedPawn
            end

        c ? c.new(piece[1].to_sym) : Empty.new
    end
end

class Queen < Piece
    def initialize(color)
        @color = color
        @movement_map = MovementMap.new(
            [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]], true, self
        )
    end

    def show
        color == :white ? '♕' : '♛'
    end
end

class King < Piece
    def initialize(color)
        @color = color
        @movement_map = MovementMap.new(
            [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]], false, self
        )
    end

    def show
        color == :white ? '♔' : '♚'
    end
end

class Rook < Piece
    def initialize(color)
        @color = color
        @movement_map = MovementMap.new([[1, 0], [0, 1], [-1, 0], [0, -1]], true, self)
    end

    def show
        color == :white ? '♖' : '♜'
    end
end

class Bishop < Piece
    def initialize(color)
        @color = color
        @movement_map = MovementMap.new([[1, 1], [1, -1], [-1, 1], [-1, -1]], true, self)
    end

    def show
        color == :white ? '♗' : '♝'
    end
end

class Knight < Piece
    def initialize(color)
        @color = color
        @movement_map = MovementMap.new(
            [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [2, -1]], false, self
        )
    end

    def show
        color == :white ? '♘' : '♞'
    end
end

class Pawn < Piece
    def initialize(color)
        @color = color
        @movement_map = MovementMap.new([[0, 1]], false, self)
    end

    def show
        color == :white ? '♙' : "\u265F"
    end
end

class UnmovedPawn < Piece
    def initialize(color)
        @color = color
        @movement_map = MovementMap.new([[0, 1], [0, 2]], false, self)
    end

    def show
        color == :white ? '♙' : "\u265F"
    end
end
