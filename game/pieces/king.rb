# frozen_string_literal: true

require './game/pieces/piece'

class King < Piece
    def movement_map
        MovementMap.new(
            [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]], false, self
        )
    end

    def checked?(position)
        board.select_color(color == :white ? :black : :white).any? do |position2|
            board.find(position).in_range? position2.piece
        end
    end

    def castling_map
        [Movement.new(2, 0), Movement.new(-2, 0)]
    end

    def possible
        return super unless board.castling[color]

        super + castling_map.each_with_object([]) do |movement, possible|
            position2 = position + movement
            position3 = position + Movement.from_a(movement / 2)
            possible << position2 if board.find(position2).empty? && !checked?(position2) && !checked?(position.to_a) && !checked?(position3)
        end
    end

    def show
        color == :white ? '♔' : '♚'
    end
end
