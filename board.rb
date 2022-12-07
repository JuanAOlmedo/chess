# frozen_string_literal: true

class Board
    attr_accessor :positions

    def initialize
        @positions = []
    end

    def select_column(x: nil, y: nil)
        @positions.select { |position| x ? position.x == x : position.y == y }
    end

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

    def show(highlight: [])
        position = [0, 7]

        puts '  A B C D E F G H'
        print '1 '
        64.times do
            str = if highlight.include?(position)
                      "#{find(position).piece.show_highlighted} "
                  else
                      "#{find(position).piece.show} "
                  end
            print str

            if position[0] < 7
                position[0] += 1
            else
                puts ''
                position[1] -= 1
                position[0] = 0
                print "#{8 - position[1]} " unless position[1] == -1
            end
        end
    end

    def move(current_color, position, position2)
        return false, 'You cannot eat your own pieces!' if position2.piece.color == current_color
        return false, 'Invalid movement' unless position.piece.possible.include? position2.to_a

        if position.piece.is_a?(UnmovedPawn)
            position2.change_piece Pawn.new(position.piece.color)
        else
            position2.change_piece position.piece
        end
        position.piece = Empty.new

        true
    end

    def selectable_position?(position, current_color)
        position.piece.color == current_color
    end

    def save
        @positions.map(&:save)
    end

    def self.load(positions)
        board = Board.new skip_build: true
        board.positions = positions.map { |position| Position.load position, board }

        board
    end
end
