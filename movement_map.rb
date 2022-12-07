# frozen_string_literal: true

# Holds the information 
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

    # If the movement map has the infinite variable assigned, calculate the biggest
    # factor by which each possible movement can be multiplied while still ending up
    # inside the board and calculate when this movement collides with another piece.
    def calculate_possible
        return calculate_possible_for_non_infinite unless infinite

        possible = map.map do |movement|
            position = piece.position
            factor = calculate_factor position.x, position.y, movement.x, movement.y

            positions = Path.new(position, movement * factor).positions

            i = positions.index { |position2| !position.board.find(position2).empty? }
            i += 1 if i && position.board.find(positions[i]).piece.color != piece.color

            positions[...i]
        end

        possible.flatten 1
    end

    private

    def calculate_factor(x, y, m1, m2)
        [m2.zero? ? 10 : (m2.positive? ? 7 - y : 0 - y) / m2,
         m1.zero? ? 10 : (m1.positive? ? 7 - x : 0 - x) / m1].min
    end

    # If infinite is false, get all the positions that are not occupied by the same
    # color as an array.
    def calculate_possible_for_non_infinite
        map.map do |movement|
            position = piece.position + movement
            piece.position.board.find(position)&.piece&.color != piece.color ? position : []
        end
    end

    def build_map(array)
        array.map do |movement|
            Movement.new(movement[0], movement[1], piece)
        end
    end
end
