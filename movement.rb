# frozen_string_literal: true

class Movement
    attr_reader :x, :y, :piece

    def initialize(x, y, piece)
        @x = x
        @y = y
        @piece = piece
    end

    def valid?
        piece.movement_map.include? self
    end

    def colinear?(movement)
        movement.x * y == movement.y * x
    end

    def equal?(other)
        other.to_a == (piece.color == :black ? to_a.map(&:abs) : to_a)
    end

    def to_a
        [x, y]
    end

    def inspect
        "In direction:  X: #{x}, Y: #{y}"
    end
end
