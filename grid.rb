class Grid

  attr_accessor :hit, :missed, :not_targeted

  MIN_X = 0
  MAX_X = 7
  MIN_Y = 0
  MAX_Y = 7

  :not_targeted
  :hit
  :missed

  def initialize(json)
    @grid = Array.new(8)
    (0..7).each { |i|
      @grid[i] = Array.new(8)
    }

    @hit = Array.new
    init_table(@hit, json['hit'], :hit)

    @missed = Array.new
    init_table(@missed, json['missed'], :missed)

    @not_targeted = Array.new
    (MIN_X..MAX_X).each { |x|
      (MIN_Y..MAX_Y).each { |y|
        if @grid[x][y].nil?
          point = Point.new(x, y, :not_targeted)
          @grid[x][y] = point
          not_targeted.push(point)
        end
      }
    }

    (MIN_X..MAX_X).each { |x|
      (MIN_Y..MAX_Y).each { |y|
        if Grid.valid_coordinates(x-1, y)
          @grid[x][y].left_neighbor = @grid[x-1][y]
        end
        if Grid.valid_coordinates(x, y+1)
          @grid[x][y].top_neighbor = @grid[x][y+1]
        end
        if Grid.valid_coordinates(x+1, y)
          @grid[x][y].right_neighbor = @grid[x+1][y]
        end
        if Grid.valid_coordinates(x, y-1)
          @grid[x][y].bottom_neighbor = @grid[x][y-1]
        end
      }
    }
  end

  def get(x, y)
    @grid[x][y]
  end

  def available_for_shoot?(x, y)
    Grid.valid_coordinates(x, y) && !@grid[x][y].already_targeted?
  end

  def already_targeted?(x, y)
    @grid[x][y].already_targeted?
  end

  # @param [Integer] x
  # @param [Integer] y
  def self.valid_coordinates(x, y)
    x >= MIN_X && x <= MAX_X && y >= MIN_Y && y <= MAX_Y
  end

  def to_s
    grid = ''
    (MIN_X..MAX_X).each { |x|
      (MIN_Y..MAX_Y).each { |y|
        case @grid[x][y].state
          when :not_targeted
            grid += ' O'
          when :hit
            grid += ' X'
          when :missed
            grid += ' #'
          else

        end
      }
      grid += "\n"
    }

    grid
  end

  private

  # @param [Array] table
  # @param [Array] points
  def init_table(table, points, state)
    points.each do |point|
      x = Integer(point[0])
      y = Integer(point[1])

      point = Point.new(x, y, state)

      table.push(point)
      @grid[x][y] = point
    end
  end
end