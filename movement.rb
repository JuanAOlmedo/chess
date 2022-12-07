# frozen_string_literal: true

# Serves as a 'vector' that goes from one position to the other
class Movement
    attr_reader :x, :y, :piece

    def initialize(x, y, piece)
        @x = x
        @y = y
        @piece = piece
    end

    def *(n)
        [x * n, y * n]
    end

    def to_a
        [x, y]
    end

    def inspect
        "In direction:  X: #{x}, Y: #{y}"
    end

    def self.from_positions(position, position2)
        movement = position2 - position
        Movement.new movement[0], movement[1], position.piece
    end
end
