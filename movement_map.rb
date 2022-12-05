# frozen_string_literal: true

class MovementMap
    attr_reader :map, :infinite, :piece

    def initialize(array, infinite, piece)
        @piece = piece
        @infinite = infinite
        @map = build_map(array)
    end

    def include?(movement)
        map.any? do |movement2|
            infinite ? movement.colinear?(movement2) : movement.equal?(movement2)
        end
    end

    def inspect
        map.map(&:inspect).inspect
    end

    private

    def build_map(array)
        array.map do |movement|
            Movement.new(movement[0], movement[1], piece)
        end
    end
end
