# frozen_string_literal: true

class Piece
    attr_accessor :position
    attr_reader :movement_map, :color

    def initialize(color)
        @color = color
    end

    def show_highlighted
        show
    end

    def possible
        movement_map.calculate_possible
    end

    def save
        [self.class.name, color]
    end

    def self.load(piece)
        Piece.subclasses.append(UnmovedPawn).find { |c| c.name == piece[0] }
             .new(piece[1].to_sym)
    end
end

class Queen < Piece
    def initialize(color)
        super
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
        super
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
        super
        @movement_map = MovementMap.new([[1, 0], [0, 1], [-1, 0], [0, -1]], true, self)
    end

    def show
        color == :white ? '♖' : '♜'
    end
end

class Bishop < Piece
    def initialize(color)
        super
        @movement_map = MovementMap.new([[1, 1], [1, -1], [-1, 1], [-1, -1]], true, self)
    end

    def show
        color == :white ? '♗' : '♝'
    end
end

class Knight < Piece
    def initialize(color)
        super
        @movement_map = MovementMap.new(
            [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [2, -1],
             [-1, 2]], false, self
        )
    end

    def show
        color == :white ? '♘' : '♞'
    end
end

class Pawn < Piece
    def initialize(color)
        super
        @movement_map = MovementMap.new([[0, color == :white ? 1 : -1]], false, self)
    end

    # Pawns can eat diagonally
    def kill_movement_map
        map = @color == :white ? [[1, 1], [-1, 1]] : [[1, -1], [-1, -1]]

        map.map.each_with_object [] do |movement, possible|
            position2 = position + Movement.new(movement[0], movement[1])

            if position.board.find(position2)&.piece&.color == (color == :white ? :black : :white)
                possible << position2
            end
        end
    end

    # Allow pawn to eat pieces diagonally but move in a straight line
    def possible
        kill_movement_map + movement_map.calculate_possible.select do |position2|
            position.board.find(position2)&.empty?
        end
    end

    def show
        color == :white ? '♙' : "\u265F"
    end
end

class UnmovedPawn < Pawn
    def initialize(color)
        super
        @movement_map = if color == :white
                            MovementMap.new([[0, 1], [0, 2]], false, self)
                        else
                            MovementMap.new([[0, -1], [0, -2]], false, self)
                        end
    end

    # Don't allow moving two steps forward if the position one step forward is occupied
    def possible
        super.select do |position2|
            if position2 == position + movement_map.map[1]
                position.board.find(position + movement_map.map[0]).empty?
            else
                true
            end
        end
    end
end
