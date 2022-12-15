# frozen_string_literal: true

# Module for Board for performing en passants https://en.wikipedia.org/wiki/En_passant
module EnPassant
    attr_accessor :en_passant

    def move(color, position, position2)
        return false unless super

        if position2.to_a == @en_passant && position2.piece.is_a?(Pawn)
            @en_passant_piece.piece = Empty.new
            @en_passant = []
            @en_passant_piece = nil
        # If a Pawn has moved two places vertically, add the position in between to the
        # variable en_passant. en_passant_piece will be the position to which the piece
        # has moved
        elsif position2.piece.is_a?(Pawn) && (position2 - position)[0].abs == 2
            @en_passant = [position.x, position.y + (color == :white ? 1 : -1)]
            @en_passant_piece = position2
        end

        true
    end
end
