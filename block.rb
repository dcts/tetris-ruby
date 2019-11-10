require 'gosu'
require 'pry-byebug'

class Block
  attr_accessor :x, :y, :dna, :color

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
    points = []
    points << {x: @x, y: @y}
    @dna.each do |cell|
      x, y = @x, @y
      cell.chars.map { |dir| MAPPING[dir] }.each do |arr|
        x, y = x+arr[0], y+arr[1]
      end
      points << {x: x, y: y}
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
    @message = Gosu::Image.from_text(self, "x = #{@x}", Gosu.default_font_name, 20)
    @message.draw(0, 5, 0)
    @message = Gosu::Image.from_text(self, "y = #{@y}", Gosu.default_font_name, 20)
    @message.draw(0, 25, 0)
  end

  def rotate
    @dna.map! { |block| block.chars.map { |char| ROTATION[char] }.join("") }
  end

  def move
    @y = @y + 1 unless floor_reached?
  end

  def floor_reached?
    floor_pos = @options.height
    diff = 0
    if @dna.any? { |block| block.include?("UU") }
      diff = 2
    elsif @dna.any? { |block| block.include?("U") }
      diff = 1
    end
    @y + diff >= floor_pos - 1
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
    Gosu::Color::WHITE,
    Gosu::Color::AQUA,
    Gosu::Color::RED,
    Gosu::Color::GREEN,
    Gosu::Color::BLUE,
    Gosu::Color::YELLOW,
    Gosu::Color::FUCHSIA,
    Gosu::Color::CYAN,
  ]
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
