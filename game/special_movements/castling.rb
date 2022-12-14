# frozen_string_literal: true

module Castling
    attr_accessor :castling

    def initialize
        super
        @castling = { white: true, black: true }
    end

    def move(color, position, position2)
        return false unless super

        # If the King or a Rook gets moved, castlings for a color are no longer possible
        castling[color] = false if [King, Rook].include? position2.piece.class

        if position2.piece.is_a?(King)
            movement = Movement.from_positions(position, position2)
            return true unless position2.piece.castling_map.map(&:to_a).include?(movement.to_a)

            # Grab the nearest rook to the king
            rooks = select_color(position2.piece.color).select { |pos| pos.piece.is_a? Rook }
            rook = rooks.min_by { |pos| (position2.x - pos.x).abs }

            # Move that rook to one position after the king
            find(position + Movement.from_a(movement / 2)).change_piece rook.piece
        end

        true
    end
end
