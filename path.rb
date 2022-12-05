# frozen_string_literal: true

class Path
    attr_reader :position, :position2, :movement, :positions

    def initialize(position, position2, movement)
        @movement = movement.to_a
        @position = position.to_a
        @position2 = position2.to_a
        @positions = []

        calculate_positions
    end

    def calculate_positions
        return unless movement[0] == movement[1] || movement.include?(0)

        max = movement.map(&:abs).max

        minimized_movement = movement.map { |coords| coords / max }

        (max - 1).times do
            @position[0] += minimized_movement[0]
            @position[1] += minimized_movement[1]
            @positions << @position.clone
        end
    end
end
