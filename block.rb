require 'gosu'

# HELPER METHOD
def sum_arr(arr_1, arr_2)
  [arr_1,arr_2].transpose.map { |el| el.reduce(&:+) }
end

class Block
  attr_accessor :x, :y

  def initialize(attr)
    @blocksize = attr[:blocksize]
    @x = attr[:width] / 2
    @y = 1
    @dna = BLOCKS.sample
    @color = COLORS.sample
  end

  def draw
    # draw origin
    Gosu.draw_rect(@x * @blocksize, @y * @blocksize, @blocksize, @blocksize, @color)
    # draw array
    @dna.each do |block|
      diff = [0, 0]
      block.chars.each { |char| diff = sum_arr(diff, MAPPING[char]) }
      Gosu.draw_rect((@x - diff[0]) * @blocksize, (@y - diff[1]) * @blocksize, @blocksize, @blocksize, @color)
    end
  end

  def rotate
  end

  def move
    @y = @y + 1;
  end

  BLOCKS = [
    ["L", "U", "UR"],
    ["U", "D", "DR"],
    ["U", "D", "DL"],
    ["L", "R", "U"],
    ["D", "U", "UU"],
    ["U", "UR", "R"],
    ["UL", "U", "R"],
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
    "U" => [0, -1],
    "D" => [0, 1],
  }
end


