# frozen_string_literal: true

module EnPassant
    attr_accessor :en_passant

    def move(color, position, position2)
        return false unless super

        if position2.to_a == @en_passant && position2.piece.is_a?(Pawn)
            @en_passant_piece.piece = Empty.new
            @en_passant = []
            @en_passant_piece = nil
        elsif position2.piece.is_a?(Pawn) && (position2 - position)[0].abs == 2
            @en_passant = [position.x, position.y + (color == :white ? 1 : -1)]
            @en_passant_piece = position2
        end

        true
    end
end
