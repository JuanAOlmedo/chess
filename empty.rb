# frozen_string_literal: true

# An empty position without any pieces on it
class Empty
    def show_highlighted
        '*'
    end

    def show
        ' '
    end

    def color
        nil
    end

    def save
        ['Empty', nil]
    end
end
