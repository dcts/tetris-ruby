require 'gosu'

class GameWindow < Gosu::Window
  def initialize(attr)
    @blocksize = attr[:blocksize]
    @x         = attr[:x]
    @y         = attr[:y]
    super(@blocksize*@x, @blocksize*@y)
  end

  def button_down(button)
    close if button == Gosu::KbEscape
    # close if button == Gosu::KbDown
    # close if button == Gosu::KbUp
    # close if button == Gosu::KbLeft
    # close if button == Gosu::KbRight
  end
end
