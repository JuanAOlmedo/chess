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

        # Return false if the position is in range of any of the pieces of the opposite
        # color
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
            # All the positions between the king to the rook, with the king and rook
            # excluded
            positions = Path.new(position, movement_to_rook(movement)).positions[..-2]

            # Check that all positions between the rook and the king are empty
            # Check that the king's position and the two positions towards the rook
            # aren't checked
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

    # Get the nearest rook to the current position with the movement added and return
    # the movement as an array to its position
    def movement_to_rook(movement)
        board.nearest_rook(board.find(position + movement), color).position - position
    end

    # Set conditions to check if the king will be checked in a certain position
    def prepare_checked(position)
        # Move the king to the position to be checked
        position.piece = self

        other_color = color == :white ? :black : :white

        # Checking if the other king will check the current king when castling is
        # unnecesary and generates an infinite loop. Disable that and save the
        # information so that it can get restored
        other_castling = board.castling[other_color]
        board.castling[other_color] = false

        [other_color, other_castling, self.position]
    end

    # Remove conditions after it has been checked
    def teardown_checked(color, castling, position, initial_position)
        board.castling[color] = castling
        position.piece = Empty.new
        initial_position.piece = self
    end
end
