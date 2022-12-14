module Castling
    attr_accessor :castling

    def initialize
        super
        @castling = { white: true, black: true }
    end

    def move(color, position, position2)
        return false unless super

        castling[color] = false if [King, Rook].include? position2.piece.class

        if position2.piece.is_a?(King)
            movement = Movement.from_positions(position, position2)
            return true unless position2.piece.castling_map.map(&:to_a).include?(movement.to_a)

            rooks = select_column(y: position2.y).select { |position| position.piece.is_a? Rook }
            rook = rooks.min_by { |position| (position2.x - position.x).abs }
            find(position + Movement.from_a(movement / 2)).change_piece rook.piece
            rook.piece = Empty.new
        end

        true
    end
end
