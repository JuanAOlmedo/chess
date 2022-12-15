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

        movement = Movement.from_positions(position, position2)
        piece = position2.piece

        return true unless piece.is_a?(King) && piece.castling_map.include?(movement)

        # Move the nearest rook to the position after the king
        find(position + Movement.from_a(movement / 2)).change_piece nearest_rook(position2,
                                                                                 color).piece

        true
    end

    private

    # Grab the nearest rook to the king, which will be used to castle
    def nearest_rook(position, color)
        positions.select { |pos| pos.piece.color == color && pos.piece.is_a?(Rook) }
                 .min_by { |pos| (position.x - pos.x).abs }
    end
end
