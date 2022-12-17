# frozen_string_literal: true

# Module for Board for performing en passants https://en.wikipedia.org/wiki/En_passant
module EnPassant
    attr_reader :en_passant

    def move(color, position, position2)
        return false unless super

        # If a Pawn has moved two places vertically, add the position in between to the
        # variable en_passant. en_passant_piece will be the position to which the piece
        # has moved
        if position2.piece.is_a?(Pawn) && (position2.y - position.y).abs == 2
            set [position.x, position.y + (color == :white ? 1 : -1)], position2
        else
            # If an en passant is being performed, kill the Pawn
            if position2 == @en_passant && position2.piece.is_a?(Pawn)
                @en_passant_piece.piece = Empty.new
            end

            # Reset variables
            set [], nil
        end

        true
    end

    private

    def set(en_passant, en_passant_piece)
        @en_passant = en_passant
        @en_passant_piece = en_passant_piece
    end
end
