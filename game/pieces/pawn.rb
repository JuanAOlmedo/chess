# frozen_string_literal: true

require './game/pieces/piece'

class Pawn < Piece
    def movement_map
        MovementMap.new([[0, color == :white ? 1 : -1]], false, self)
    end

    def diagonals
        @color == :white ? [[1, 1], [-1, 1]] : [[1, -1], [-1, -1]]
    end

    # Pawns can eat diagonally
    def kill_movement_map
        diagonals.map.each_with_object [] do |movement, possible|
            position2 = position + Movement.new(movement[0], movement[1])

            if position.board.find(position2)&.piece&.color == (color == :white ? :black : :white)
                possible << position2
            end
        end
    end

    def en_passant
        return [] if board.en_passant.nil? || board.en_passant.empty?

        if diagonals.include?(Movement.from_a(board.en_passant) - position)
            return [board.en_passant]
        end

        []
    end

    # Allow pawn to eat pieces diagonally but move in a straight line
    def possible
        kill_movement_map + en_passant + movement_map.calculate_possible.select do |position2|
            position.board.find(position2)&.empty?
        end
    end

    def show
        color == :white ? '♙' : "\u265F"
    end
end
