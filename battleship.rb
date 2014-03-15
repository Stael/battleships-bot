class Battleship

  def initialize(json)
    @grid            = Grid.new(json)
    @destroyed_ships = json['destroyed']
    #puts @grid

    generate_points()
  end

  def shoot
    point = smart_shoot
    if point.nil? || point.already_targeted?
      Battleship.do_move(probe_shoot, 'not smart')
    else
      Battleship.do_move(point, 'smart')
    end

  end

  private
  # @return [Point]
  def smart_shoot
    @grid.hit.each do |point|
      unless point.neighbor_hit?
        return find_neighbor(point, 1, 1)
      end

      if !point.left_neighbor.nil? && point.left_neighbor.was_hit? && !point.right_neighbor.nil? && !point.right_neighbor.already_targeted?
        return point.right_neighbor
      elsif !point.top_neighbor.nil? && point.top_neighbor.was_hit? && !point.bottom_neighbor.nil? && !point.bottom_neighbor.already_targeted?
        return point.bottom_neighbor
      elsif !point.right_neighbor.nil? && point.right_neighbor.was_hit? && !point.left_neighbor.nil? && !point.left_neighbor.already_targeted?
        return point.left_neighbor
      elsif !point.bottom_neighbor.nil? && point.bottom_neighbor.was_hit? && !point.top_neighbor.nil? && !point.top_neighbor.already_targeted?
        return point.top_neighbor
      else
        x_margin = point.x%2 == 0 ? max(1, smallest_ship_alive-1) : max(2, smallest_ship_alive-1)
        y_margin = point.y%2 == 0 ? max(1, smallest_ship_alive-1) : max(2, smallest_ship_alive-1)

        shootable_point = find_neighbor(point, x_margin, y_margin)
        unless shootable_point.nil?
          return shootable_point
        end
      end
    end

    nil
  end

  # @return [Point]
  def probe_shoot
    max_score  = @points[0].score
    tmp_points = Array.new
    @points.each do |point|
      if point.score == max_score
        tmp_points.push(point)
      end
    end

    tmp_points[rand(tmp_points.length)]
  end

  # @param [Point] square
  def self.do_move(square, type)
    move = {'move' => square.to_s, 'shoot_type' => type}
    puts JSON.generate(move)
  end

  def max(a, b)
    a > b ? a : b
  end

  def smallest_ship_alive
    ([2, 3, 4, 5] - @destroyed_ships).min
  end

  def generate_points
    @points = Array.new

    @grid.not_targeted.each do |point|
      score = 0
      (2..5).each { |size|
        unless @destroyed_ships.include?(size)
          score += search_ships(point, true, size)
          score += search_ships(point, false, size)
        end
      }
      point.score=score
      @points.push(point)
    end

    @points.sort!.reverse!
  end

  # @param [Point] point
  # @param [Boolean] x_vary
  # @param [Integer] size
  # @return [Integer]
  def search_ships(point, x_vary, size)
    score    = 0
    variable = x_vary ? point.x : point.y
    min      = variable-size-1 < 0 ? 0 : variable-size-1

    (min..variable).each { |var_min|
      might_contains_ship = true
      max                 = var_min+size-1 > 7 ? 7 : var_min+size-1

      #puts 'size : ' + size.to_s + ' min : ' + var_min.to_s + ' max : ' + max.to_s
      if max-var_min+1 != size
        #puts '-> continue'
        next
      end

      (var_min..max).each { |var|
        if @grid.already_targeted?(x_vary ? var : point.x, x_vary ? point.y : var)
          might_contains_ship = false
          break
        end
      }

      if might_contains_ship
        score += 1
      end
    }

    score
  end

  def find_neighbor(point, x_margin, y_margin)
    if @grid.available_for_shoot?(point.x+x_margin, point.y)
      @grid.get(point.x+x_margin, point.y)
    elsif @grid.available_for_shoot?(point.x-x_margin, point.y)
      @grid.get(point.x-x_margin, point.y)
    elsif @grid.available_for_shoot?(point.x, point.y+y_margin)
      @grid.get(point.x, point.y+y_margin)
    elsif @grid.available_for_shoot?(point.x, point.y-y_margin)
      @grid.get(point.x, point.y-y_margin)
    else
      nil
    end
  end
end