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

    # MovementMap for castlings
    def castling_map
        [Movement.new(2, 0), Movement.new(-2, 0)]
    end

    def castling
        castling_map.each_with_object [] do |movement, possible|
            positions = [position + Movement.from_a(movement / 2), position + movement]

            # Check that all positions from the current position to the movement
            # position aren't checked and are empty
            if positions.all? { |pos| board.find(pos).empty? && !checked?(pos) } &&
               !checked?(position.to_a)
                possible << positions[1]
            end
        end
    end

    # If castlings are possible, return castlings alongside other possible moves
    def possible
        board.castling[color] ? super + castling : super
    end

    def show
        color == :white ? '♔' : '♚'
    end
end
