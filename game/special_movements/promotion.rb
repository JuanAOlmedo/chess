# frozen_string_literal: true

# Work in progress

# Module for Board for performing pawn promotion
# https://en.wikipedia.org/wiki/Promotion_(chess)
module Promotion
    def move(color, position, position2)
        return false unless super

        # When a Pawn reaches the last possible line, promote it
        if position2.piece.is_a?(Pawn) && position2.y == (color == :white ? 7 : 0)
            # Do nothing
            # position2.change_piece Queen.new(color, self)
        end

        true
    end
end
