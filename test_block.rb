require_relative 'options'
require_relative 'block'

o = Options.new(
  blocksize: 30,
  width: 10,
  height: 20,
  background: Gosu::Color::BLACK
)
