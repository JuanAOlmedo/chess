# frozen_string_literal: true

require './game/pieces/piece'

class Rook < Piece
    def movement_map
        MovementMap.new([[1, 0], [0, 1], [-1, 0], [0, -1]], true, self)
    end

    def show
        color == :white ? '♖' : '♜'
    end
end
