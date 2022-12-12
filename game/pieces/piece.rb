# frozen_string_literal: true

# The Piece class is used as a base for every other piece class.
class Piece
    attr_accessor :position
    attr_reader :movement_map, :color

    def initialize(color)
        @color = color
    end

    def show_highlighted
        show
    end

    def possible
        movement_map.calculate_possible
    end

    def save
        [self.class.name, color]
    end

    def self.load(piece)
        Piece.subclasses.append(UnmovedPawn).find { |c| c.name == piece[0] }
             .new(piece[1].to_sym)
    end
end
