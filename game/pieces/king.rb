# frozen_string_literal: true

require './game/pieces/piece'

class King < Piece
    def movement_map
        MovementMap.new(
            [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]], false, self
        )
    end

    def checked?(position)
        position = board.find(position)
        other_color, other_castling, initial_position = prepare_checked position

        checked = board.select_color(other_color).any? do |position2|
            position.in_range? position2.piece
        end

        teardown_checked other_color, other_castling, position, initial_position

        checked
    end

    # MovementMap for castlings
    def castling_map
        [Movement.new(2, 0), Movement.new(-2, 0)]
    end

    def castling
        castling_map.each_with_object [] do |movement, possible|
            positions = Path.new(position, movement_to_rook(movement)).positions[..-2]

            # Check that all positions from the current position to the movement
            # position aren't checked and are empty
            if positions.all? { |pos| board.find(pos).empty? } &&
               positions[..1].append(position.to_a).all? { |pos| !checked?(pos) }
                possible << positions[1]
            end
        end
    end

    # If castlings are possible, return castlings alongside other possible moves
    def possible
        board.castling[color] ? super + castling : super
    end

    def show
        color == :white ? '♔' : '♚'
    end

    private
    
    def movement_to_rook(movement)
        board.nearest_rook(board.find(position + movement), color).position - position
    end

    def prepare_checked(position)
        position.piece = self
        other_color = color == :white ? :black : :white
        other_castling = board.castling[other_color]
        board.castling[other_color] = false

        [other_color, other_castling, self.position]
    end

    def teardown_checked(color, castling, position, initial_position)
        board.castling[color] = castling
        position.piece = Empty.new
        initial_position.piece = self
    end
end
