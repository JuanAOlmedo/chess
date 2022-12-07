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

    # If the movement map has the infinite variable assigned, calculate the biggest
    # factor by which each possible movement can be multiplied while still ending up inside the board. Else return the movement map itself converted to array.
    def calculate_possible
        unless infinite
            return map.map do |movement|
                position = [piece.position.x + movement.x, piece.position.y + movement.y]
                piece.position.board.find(position) && piece.position.board.find(position).empty? ? position : []
            end
        end

        possible = map.map do |movement|
            x, y = piece.position.to_a
            m1, m2 = movement.to_a

            factor = [if m2.zero?
                          10
                      else
                          ((m2.positive? ? 7 : 0) - y) / m2
                      end,
                      if m1.zero?
                          10
                      else
                          ((m1.positive? ? 7 : 0) - x) / m1
                      end].min

            movement = [movement.x * factor, movement.y * factor]
            positions = Path.new(piece.position, movement).positions

            i = positions.index { |position| piece.position.board.find(position).empty? }
            i -= 1 if piece.position.board.find(positions[i]).piece.color == piece.color

            positions[...i]
        end

        possible.flatten 1
    end

    private

    def build_map(array)
        array.map do |movement|
            Movement.new(movement[0], movement[1], piece)
        end
    end
end
