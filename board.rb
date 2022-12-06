# frozen_string_literal: true

class Board
    attr_accessor :positions

    def initialize(skip_build: false)
        @positions = []
        build_empty unless skip_build
    end

    def select_column(x: nil, y: nil)
        if x
            @positions.select { |position| position.x == x }
        else
            @positions.select { |position| position.y == y }
        end
    end

    def find(array)
        @positions.find { |position| position.to_a in ^array }
    end

    def kings
        @positions.select { |position| position.piece.is_a? King }.map(&:piece)
    end

    def black_king
        kings.find { |piece| piece.color == :black }
    end

    def white_king
        kings.find { |piece| piece.color == :white }
    end

    def build_empty
        position = { x: 0, y: 0 }
        64.times do
            @positions << Position.new(position[:x], position[:y], self, piece: Empty.new)

            if position[:x] < 7
                position[:x] += 1
            else
                position[:y] += 1
                position[:x] = 0
            end
        end

        select_column(y: 1).map { |position| position.change_piece(UnmovedPawn.new(:white)) }
        select_column(y: 6).map { |position| position.change_piece(UnmovedPawn.new(:black)) }

        column_0 = select_column(y: 0)
        column_0[0].change_piece Rook.new(:white)
        column_0[1].change_piece Knight.new(:white)
        column_0[2].change_piece Bishop.new(:white)
        column_0[3].change_piece Queen.new(:white)
        column_0[4].change_piece King.new(:white)
        column_0[5].change_piece Bishop.new(:white)
        column_0[6].change_piece Knight.new(:white)
        column_0[7].change_piece Rook.new(:white)

        column_7 = select_column(y: 7)
        column_7[0].change_piece Rook.new(:black)
        column_7[1].change_piece Knight.new(:black)
        column_7[2].change_piece Bishop.new(:black)
        column_7[3].change_piece Queen.new(:black)
        column_7[4].change_piece King.new(:black)
        column_7[5].change_piece Bishop.new(:black)
        column_7[6].change_piece Knight.new(:black)
        column_7[7].change_piece Rook.new(:black)
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

    def show_possible(current_color, position)
        possible = @positions.select do |position2|
            movement = Movement.from_positions position, position2
            check_valid(current_color, position, position2, movement)[0]
        end
        
        show highlight: possible.map(&:to_a)
    end

    def move(current_color, position, position2)
        movement = Movement.new position2.x - position.x, position2.y - position.y, position.piece

        valid, reason = check_valid(current_color, position, position2, movement)
        return false, reason unless valid

        if position.piece.is_a?(UnmovedPawn)
            position2.change_piece Pawn.new(position.piece.color)
        else
            position2.change_piece position.piece
        end
        position.piece = Empty.new

        true
    end

    def check_valid(current_color, position, position2, movement)
        return false, 'Not your piece!' if position.piece.color != current_color

        return false, 'You cannot eat your own pieces!' if position2.piece.color == current_color

        if position2.x > 7 || position2.y > 7
            return false, 'You cannot move the piece outisde the board'
        end

        return false, 'Invalid movement' unless movement.valid?

        if Path.new(position, position2, movement).positions.any? { |p| !find(p).empty? }
            return false, 'There are pieces inbetween'
        end

        return true, ''
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
