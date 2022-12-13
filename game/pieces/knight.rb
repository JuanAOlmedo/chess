# frozen_string_literal: true

require './game/pieces/piece'

class Knight < Piece
    def movement_map
        MovementMap.new(
            [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [2, -1],
             [-1, 2]], false, self
        )
    end

    def show
        color == :white ? '♘' : '♞'
    end
end
