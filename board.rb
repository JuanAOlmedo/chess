# frozen_string_literal: true

# The playing board, which holds an array of all the possible positions
class Board
    attr_accessor :positions
    BOARD = "
  A B C D E F G H
1 [0, 7] [1, 7] [2, 7] [3, 7] [4, 7] [5, 7] [6, 7] [7, 7]
2 [0, 6] [1, 6] [2, 6] [3, 6] [4, 6] [5, 6] [6, 6] [7, 6]
3 [0, 5] [1, 5] [2, 5] [3, 5] [4, 5] [5, 5] [6, 5] [7, 5]
4 [0, 4] [1, 4] [2, 4] [3, 4] [4, 4] [5, 4] [6, 4] [7, 4]
5 [0, 3] [1, 3] [2, 3] [3, 3] [4, 3] [5, 3] [6, 3] [7, 3] 6 [0, 2] [1, 2] [2, 2] [3, 2] [4, 2] [5, 2] [6, 2] [7, 2]
7 [0, 1] [1, 1] [2, 1] [3, 1] [4, 1] [5, 1] [6, 1] [7, 1]
8 [0, 0] [1, 0] [2, 0] [3, 0] [4, 0] [5, 0] [6, 0] [7, 0]\n"

    def initialize
        @positions = []
    end

    # Find a column or row
    def select_column(x: nil, y: nil)
        @positions.select { |position| x ? position.x == x : position.y == y } end
    # Find the position that matches the coordinates
    def find(array)
        @positions.find { |position| position.to_a in ^array }
    end

    def kings
        @positions.select { |position| position.piece.is_a? King }.map(&:piece)
    end

    def black_king
        kings.find { |king| king.color == :black }
    end

    def white_king
        kings.find { |king| king.color == :white }
    end

    def board()
        BOARD.gsub(/\[.{4}\]/) do |position|
            find([position[1].to_i, position[4].to_i]).piece.show
        end
    end

    def highlight(highlight, window)
        window.attrset Curses::A_BLINK

        highlight.each do |to_highlight|
            window.setpos(9 - to_highlight[1], to_highlight[0] * 2 + 2)
            window.addstr find(to_highlight).piece.show_highlighted
        end

        window.attrset Curses::A_NORMAL
    end

    # Move a piece from one position to another if the movement is valid
    def move(current_color, position, position2)
        return false if position2.piece.color == current_color
        return false unless position.piece.possible.include? position2.to_a

        if position.piece.is_a?(UnmovedPawn)
            position2.change_piece Pawn.new(position.piece.color)
        else
            position2.change_piece position.piece
        end
        position.piece = Empty.new

        true
    end

    def save
        @positions.map(&:save)
    end

    def self.load(positions)
        board = Board.new
        board.positions = positions.map { |position| Position.load position, board }

        board
    end
end
