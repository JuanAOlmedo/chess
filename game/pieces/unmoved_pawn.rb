# frozen_string_literal: true

require './game/pieces/piece'

# A Pawn that has not been moved
class UnmovedPawn < Pawn
    def movement_map
        if color == :white
            MovementMap.new([[0, 1], [0, 2]], false, self)
        else
            MovementMap.new([[0, -1], [0, -2]], false, self)
        end
    end

    # Don't allow moving two steps forward if the position one step forward is occupied
    def possible
        super.select do |position2|
            if position2 == position + movement_map.map[1]
                position.board.find(position + movement_map.map[0]).empty?
            else
                true
            end
        end
    end
end
