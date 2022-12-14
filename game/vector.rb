# frozen_string_literal: true

# Used by positions and movements. Defines basic operations that can be done with a
# vector (sums with other vectors, multiplication by an integer)
module Vector
    def +(other)
        [x + other.x, y + other.y]
    end

    def -(other)
        [x - other.x, y - other.y]
    end

    def *(other)
        [x * other, y * other]
    end

    def /(other)
        [x / other, y / other]
    end

    def ==(other)
        to_a == other.to_a
    end

    def to_a
        [x, y]
    end
    alias deconstruct to_a
end
