require 'gosu'
require_relative 'block'
require_relative 'options'
# require_relative 'defstruct'

class GameWindow < Gosu::Window
  def initialize(options)
    @count = 0
    @options = options
    @field = initialize_field # representation of field as string
    # init window
    super(@options.blocksize*@options.width, @options.blocksize*@options.height)
    self.caption = "TETRIS RUBY"
    # random block
    @block = Block.new(@options)
  end

  # returns printable fieldstring (converted from fieldarray)
  def fieldstr # 0: empty space, 1: wall, 2: current block
    convert = {0 => ".", 1 => "x", 2 => "@" }
    @field.map { |row| row.map { |cell| convert[cell] }.join }.join("\n")
  end

  def initialize_field # created string that represents gamefield
    Array.new(@options.height,Array.new(@options.width, 0)) # .map(&:join).join("\n")
  end

  def button_down(button)
    close if button == Gosu::KbEscape
    @block = Block.new(@options) if button == Gosu::KbReturn
    @block.rotate if button == Gosu::KbSpace
    @block.x = @block.x + 1 if button == Gosu::KbRight
    @block.x = @block.x - 1 if button == Gosu::KbLeft
    @block.y = @block.y + 1 if button == Gosu::KbDown
    @block.y = @block.y - 1 if button == Gosu::KbUp
  end

  def draw
    if (@count % 6).zero?
      @block.move
      puts "FIELD: \n\n#{fieldstr}"
    end
    @count += 1
    @block.draw
  end
end

# run the game
# start.rb
game = GameWindow.new(Options.new(
  blocksize: 30,
  width: 10,
  height: 20,
  background: Gosu::Color::BLACK
)).show
