# frozen_string_literal: true

require './game/pieces/piece'

class Bishop < Piece
    def initialize(color)
        super
        @movement_map = MovementMap.new([[1, 1], [1, -1], [-1, 1], [-1, -1]], true, self)
    end

    def show
        color == :white ? '♗' : '♝'
    end
end
