require 'gosu'
require 'pry-byebug'

class Block
  attr_accessor :x, :y, :dna, :color, :options, :message

  def self.copy(block)
    copied_block = Block.new(block.options)
    copied_block.dna = block.dna
    copied_block.color = block.color
    copied_block.x = block.x
    copied_block.y = block.y
    return copied_block
  end

  def initialize(options)
    @options = options
    @dna = BLOCKS.sample
    @color = COLORS.sample
    @x = @options.width / 2
    @y = 0
  end

  def blocksize
    @options.blocksize
  end

  def coordinates
    Block.dna_to_coordinates(@dna, @x, @y)
  end

  def self.dna_to_coordinates(dna, x, y)
    points = []
    points << {x: x, y: y}
    dna.each do |cell|
      x_new, y_new = x, y
      cell.chars.map { |dir| MAPPING[dir] }.each do |arr|
        x_new += arr[0]
        y_new += arr[1]
      end
      points << {x: x_new, y: y_new}
    end
    return points
  end

  def draw
    # draw origin
    Gosu.draw_rect(@x * blocksize, @y * blocksize, blocksize, blocksize, @color)
    # draw array
    @dna.each do |block|
      x, y = @x, @y
      block.chars.each do |char|
        x, y = x+MAPPING[char][0], y+MAPPING[char][1]
      end
      Gosu.draw_rect(x * blocksize, y * blocksize, blocksize, blocksize, @color)
    end
  end

  def draw_ghost(field)
    ghost = Block.copy(self)
    ghost.move_all_down(field)
    # draw origin
    Gosu.draw_rect(ghost.x * blocksize, ghost.y * blocksize, blocksize, blocksize, color_ghost)
    # draw array
    ghost.dna.each do |block|
      x, y = ghost.x, ghost.y
      block.chars.each do |char|
        x, y = x+MAPPING[char][0], y+MAPPING[char][1]
      end
      Gosu.draw_rect(x * blocksize, y * blocksize, blocksize, blocksize, color_ghost)
    end
  end

  def rotate(field)
    dna_future = @dna.map { |block| block.chars.map { |char| ROTATION[char] }.join("") }
    @dna = dna_future unless Block.collision?(field, Block.dna_to_coordinates(dna_future, @x, @y))
  end

  def move(action = "down", field) # down
    # copy block and compte future state
    block_new = Block.copy(self)
    if action == "down"
      block_new.y = block_new.y + 1
    elsif action == "up"
      block_new.y = block_new.y - 1
    elsif action == "left"
      block_new.x = block_new.x - 1
    elsif action == "right"
      block_new.x = block_new.x + 1
    end

    # only apply changes if no collision
    unless Block.collision?(field, block_new.coordinates)
      @x = block_new.x
      @y = block_new.y
    end
  end

  def move_all_down(field)
    move("down", field) until ground_reached?(field)
  end

  def self.collision?(field, coordinates)
    coordinates.each do |point|
      return true if point[:y] >= field.size || point[:x] >= field[0].size # outside of fields scope
      return true if point&.[](:x) < 0 || point&.[](:y) < 0 || field[point[:y]][point[:x]] > 0
    end
    return false
  end

  def ground_reached?(field)
    # simulate a move down
    x_future = @x
    y_future = @y + 1
    coordinates_future = Block.dna_to_coordinates(@dna, x_future, y_future)
    # check if a collision occurs
    Block.collision?(field, coordinates_future)
  end

  BLOCKS = [
    ["L", "D", "DR"],
    ["D", "U", "UR"],
    ["D", "U", "UL"],
    ["L", "R", "D"],
    ["U", "D", "DD"],
    ["D", "DR", "R"],
    ["DL", "D", "R"],
  ]
  COLORS = [
    # Gosu::Color::WHITE,
    # Gosu::Color::AQUAblock,
    # Gosu::Color::RED,
    # Gosu::Color::GREEN,
    # Gosu::Color::BLUE,
    Gosu::Color::YELLOW,
    # Gosu::Color::FUCHSIA,
    # Gosu::Color::CYAN,
  ]

  def color_ghost
    color = Gosu::Color::BLACK.dup
    color.red = 235
    color.green = 241
    color.blue = 158
    return color
  end

  MAPPING = {
    "L" => [-1, 0],
    "R" => [1, 0],
    "D" => [0, 1],
    "U" => [0, -1],
  }
  ROTATION = {
    "L" => "U",
    "U" => "R",
    "R" => "D",
    "D" => "L",
  }
end

# HELPER METHOD (deprecated -> not needed anymore)
def sum_arr(arr_1, arr_2)
  [arr_1,arr_2].transpose.map { |el| el.reduce(&:+) }
end
