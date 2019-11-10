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
    @field.map { |row| row.map { |cell| code2char(cell) }.join }.join("\n")
  end

  def initialize_field # created string that represents gamefield
    Array.new(@options.height,Array.new(@options.width, 0)) # .map(&:join).join("\n")
  end

  def button_down(button)
    close if button == Gosu::KbEscape
    press_enter if button == Gosu::KbReturn
    @block.rotate if button == Gosu::KbSpace
    @block.x = @block.x + 1 if button == Gosu::KbRight
    @block.x = @block.x - 1 if button == Gosu::KbLeft
    @block.y = @block.y + 1 if button == Gosu::KbDown
    @block.y = @block.y - 1 if button == Gosu::KbUp
  end

  def draw
    if (@count % 6).zero?
      # @block.move
      puts "FIELD: \n\n#{fieldstr}"
    end
    @count += 1
    draw_field # draw playing fielld
    @block.draw # draw current block
  end

  def draw_field

  end

  private

  def press_enter
    puts "hi from save block"
    # add block to wall
    binding.pry
  end

  def code2color(code)
    COLORCODES[code]
  end

  def color2code(color) #color is as Gosu::Color:: object
    COLORCODES_REVERSED[color]
  end

  def code2char(code)
    return code == 0 ? "." : code == 1 ? "@" : "x"
  end

  COLORCODES = {
    2 => Gosu::Color::AQUA,
    3 => Gosu::Color::RED,
    4 => Gosu::Color::GREEN,
    5 => Gosu::Color::BLUE,
    6 => Gosu::Color::YELLOW,
    7 => Gosu::Color::FUCHSIA,
    8 => Gosu::Color::CYAN,
    9 => Gosu::Color::WHITE
  }
  COLORCODES_REVERSED = {
    Gosu::Color::AQUA => 2,
    Gosu::Color::RED => 3,
    Gosu::Color::GREEN => 4,
    Gosu::Color::BLUE => 5,
    Gosu::Color::YELLOW => 6,
    Gosu::Color::FUCHSIA => 7,
    Gosu::Color::CYAN => 8,
    Gosu::Color::WHITE => 9
  }
end

# run the game
# start.rb
game = GameWindow.new(Options.new(
  blocksize: 30,
  width: 10,
  height: 20,
  background: Gosu::Color::BLACK
)).show
