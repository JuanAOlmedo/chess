# frozen_string_literal: true

require './game/pieces/piece'

class Queen < Piece
    def initialize(color)
        super
        @movement_map = MovementMap.new(
            [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]], true, self
        )
    end

    def show
        color == :white ? '♕' : '♛'
    end
end
