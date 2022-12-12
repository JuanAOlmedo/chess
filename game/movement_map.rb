# frozen_string_literal: true

# Holds an array of all the possible movements a piece can make. If infinite is true,
# it means that the piece can continue in the direction of every movement until the end
# of the board
class MovementMap
    attr_reader :map, :infinite, :piece

    def initialize(array, infinite, piece)
        @piece = piece
        @infinite = infinite
        @map = build_map(array)
    end

    def inspect
        map.map(&:inspect).inspect
    end

    # Calculate all possible movements a piece can make in a given position
    def calculate_possible
        return calculate_possible_for_non_infinite unless infinite

        possible = map.map do |movement|
            position = piece.position
            factor = calculate_factor position.x, position.y, movement.x, movement.y

            # movement * factor represents the biggest movement a piece can make
            # while still being on the board
            # positions are all the positions between the initial position of the piece
            # and the final position of this movement
            positions = Path.new(position, movement * factor).positions

            # Calculate the first position from the path that has pieces on it
            i = positions.index { |position2| !position.board.find(position2).empty? }
            i += 1 if i && position.board.find(positions[i]).piece.color != piece.color

            positions[...i]
        end

        possible.flatten 1
    end

    private

    # Calculate the biggest factor by which a movement [m1, m2] can be multiplied with
    # respect to a position [x, y] so that it ends up being just on the border of the
    # board
    def calculate_factor(x, y, m1, m2)
        [if m2.zero?
             10
         else
             (m2.positive? ? 7 - y : 0 - y) / m2
         end,
         if m1.zero?
             10
         else
             (m1.positive? ? 7 - x : 0 - x) / m1
         end].min
    end

    # If infinite is false, get all the positions that are not occupied by the same
    # color as an array.
    def calculate_possible_for_non_infinite
        map.each_with_object([]) do |movement, possible|
            position = piece.position.board.find piece.position + movement
            possible << position.to_a if position && position.piece.color != piece.color
        end
    end

    def build_map(array)
        array.map { |movement| Movement.new movement[0], movement[1] }
    end
end
