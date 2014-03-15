class Point
  include Comparable

  attr_accessor :x, :y, :score, :state,
                :left_neighbor, :top_neighbor, :right_neighbor, :bottom_neighbor

  def initialize(x, y, state)
    @x     = x
    @y     = y
    @score = 0
    @state = state

    @left_neighbor = nil
    @top_neighbor = nil
    @right_neighbor = nil
    @bottom_neighbor = nil
  end

  def to_s
    @x.to_s + @y.to_s
  end

  def self.serialize(x, y)
    x.to_s + y.to_s
  end

  def <=>(point)
    @score <=> point.score
  end

  def already_targeted?
    state != :not_targeted
  end

  def was_hit?
    state == :hit
  end

  def neighbor_hit?
    left_neighbor_hit = !@left_neighbor.nil? && @left_neighbor.was_hit?
    top_neighbor_hit = !@top_neighbor.nil? && @top_neighbor.was_hit?
    right_neighbor_hit = !@right_neighbor.nil? && @right_neighbor.was_hit?
    bottom_neighbor_hit = !@bottom_neighbor.nil? && @bottom_neighbor.was_hit?

    left_neighbor_hit || top_neighbor_hit || right_neighbor_hit || bottom_neighbor_hit
  end
end