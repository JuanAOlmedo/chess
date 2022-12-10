# frozen_string_literal: true

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

    def to_a
        [x, y]
    end
end
