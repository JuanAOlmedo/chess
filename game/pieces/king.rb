# frozen_string_literal: true

require './game/pieces/piece'

class King < Piece
    def initialize(color)
        super
        @movement_map = MovementMap.new(
            [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]], false, self
        )
    end

    def show
        color == :white ? '♔' : '♚'
    end
end
