# frozen_string_literal: true

# Calculates all the positions between a position and a specified movement
class Path
    attr_reader :position, :movement, :positions

    def initialize(position, movement)
        @movement = movement.to_a
        @position = position.to_a
        @positions = []

        calculate_positions
    end

    def calculate_positions
        return if movement == [0, 0]
        return unless movement[0].abs == movement[1].abs || movement.include?(0)

        max = movement.map(&:abs).max
        minimized_movement = movement.map { |coords| coords / max }

        max.times do
            @position[0] += minimized_movement[0]
            @position[1] += minimized_movement[1]
            @positions << @position.clone
        end
    end
end
