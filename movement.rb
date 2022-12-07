# frozen_string_literal: true

class Movement
    attr_reader :x, :y, :piece

    def initialize(x, y, piece)
        @x = x
        @y = y
        @piece = piece
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
