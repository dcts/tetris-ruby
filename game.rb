require 'gosu'
require_relative 'block'
# require_relative 'defstruct'

class GameWindow < Gosu::Window

  def initialize(attr)
    @count = 0
    @blocksize = attr[:blocksize]
    @width  = 10
    @height = 20
    attr[:width]  = @width
    attr[:height] = @height
    @attr = attr;

    # init window
    super(@blocksize*@width, @blocksize*@height)
    self.caption = "TETRIS RUBY"

    # random block
    @block = Block.new(@attr)
  end

  def button_down(button)
    close if button == Gosu::KbEscape
    @block = Block.new(@attr) if button == Gosu::KbSpace
    @block.x = @block.x + 1 if button == Gosu::KbRight
    @block.x = @block.x - 1 if button == Gosu::KbLeft
  end

  def draw
    if (@count % 5).zero?
      @block.move
    end
    @count += 1
    @block.draw
  end
end

# run the game
# start.rb
game = GameWindow.new(
  blocksize: 30,
  width: 30,
  height: 30,
  background: Gosu::Color::BLACK,
).show
