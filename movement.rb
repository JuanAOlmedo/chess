# frozen_string_literal: true

class Movement
    attr_reader :x, :y, :piece

    def initialize(x, y, piece)
        @x = x
        @y = y
        @piece = piece
    end

    def valid?
        if piece.is_a?(Pawn) || piece.is_a?(UnmovedPawn)
            position2 = piece.position.board.find([piece.position.x + x,
                                                   piece.position.y + y]).empty?

            if piece.kill_movement_map.include? self
                !position2
            elsif piece.movement_map.include? self
                position2
            end
        else
            piece.movement_map.include? self
        end
    end

    def colinear?(movement)
        movement.x * y == movement.y * x
    end

    def equal?(other)
        other.to_a == (piece.color == :black ? to_a.map { |c| c * -1 } : to_a)
    end

    def to_a
        [x, y]
    end

    def inspect
        "In direction:  X: #{x}, Y: #{y}"
    end

    def self.from_positions(position, position2)
        Movement.new position2.x - position.x, position2.y - position.y, position.piece
    end
end
