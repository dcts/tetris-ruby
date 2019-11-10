class Options
  attr_reader :blocksize, :width, :height, :background

  def initialize(attr)
    @blocksize = attr[:blocksize]
    @width  = attr[:width]
    @height = attr[:height]
    @background = attr[:background]
  end
end
