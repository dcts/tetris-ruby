require 'gosu'
require 'pry-byebug'

# HELPER METHOD
def sum_arr(arr_1, arr_2)
  [arr_1,arr_2].transpose.map { |el| el.reduce(&:+) }
end

class Block
  attr_accessor :x, :y

  def initialize(attr)
    @attr = attr
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
    @dna.map! { |block| block.chars.map { |char| ROTATION[char] }.join("") }
  end

  def move
    @y = @y + 1 unless floor_reached?
  end


  def floor_reached?
    floor_pos = @attr[:height]
    diff = 0
    if @dna.any? { |block| block.include?("DD") }
      diff = 2
    elsif @dna.any? { |block| block.include?("D") }
      diff = 1
    end
    @y + diff == floor_pos
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
    "U" => [0, -1],
    "D" => [0, 1],
  }
  ROTATION = {
    "L" => "U",
    "U" => "R",
    "R" => "D",
    "D" => "L",
  }
end


