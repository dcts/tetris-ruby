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

  def update_field(x,y,val)
    field_dup = @field.map(&:dup) # need to duplicate original array
    field_dup[y][x] = val
    @field = field_dup
  end

  def initialize_field # created string that represents gamefield
    Array.new(@options.height,Array.new(@options.width, 0)) # .map(&:join).join("\n")
  end

  def button_down(button)
    close if button == Gosu::KbEscape
    press_enter if button == Gosu::KbReturn
    @block.rotate(@field) if button == Gosu::KbSpace
    @block.move("right", @field) if button == Gosu::KbRight
    @block.move("left", @field)  if button == Gosu::KbLeft
    @block.move("down", @field)  if button == Gosu::KbDown
    @block.move("up", @field)    if button == Gosu::KbUp
  end

  def draw
    if (@count % 6).zero?
      puts "FIELD: \n\n#{fieldstr}"
      puts @block.dna
      # @block.move("down", @field)
      # if @block.floor_reached?
      #   binding.pry
      # end
    end
    @count += 1
    draw_field # draw playing fielld
    @block.draw # draw current block
  end

  def draw_field
    r = 0
    @field.each do |row|
      c = 0
      row.each do |col|
        Gosu.draw_rect(c * blocksize, r * blocksize, blocksize, blocksize, COLORCODES[col]) if col != 0
        c += 1
      end
      r += 1
    end
  end

  private

  def blocksize
    @options.blocksize
  end

  def press_enter
    puts "ENTER PRESSED -> checking if floor reached"
    puts "collision: #{@block.floor_reached?}"
    # add block to wall
    @block.coordinates.each do |point|
      update_field(point[:x], point[:y], COLORCODES_REVERSED[@block.color])
    end
    @block = Block.new(@options)
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
