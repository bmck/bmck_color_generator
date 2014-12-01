# Derived from work found at http://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/

class ColorGenerator
  attr_accessor :h, :s, :v
  cattr_reader :golden_ratio_conjugate do 0.6180339887498953 end

  class << self
    def to_hsv(r, g, b)
      # Convert an arbitrary RGB triple to HSV
      #
      # Example:
      #   > ColorGenerator.to_hsv(0.1, 0.85, 0.98)
      #   => [0.6666666666666666, 0.8979591836734694, 0.98]
      #
      # Arguments:
      #   r, g, b: (Numeric)

      r = r.to_i(16).to_s(10).to_i if r.is_a?(String) && r =~ /^[0-9A-F]{1-2}$/i
      g = g.to_i(16).to_s(10).to_i if g.is_a?(String) && g =~ /^[0-9A-F]{1-2}$/i
      b = b.to_i(16).to_s(10).to_i if b.is_a?(String) && b =~ /^[0-9A-F]{1-2}$/i

      fail RunTimeError('Invalid input argument.') unless r.is_a?(Numeric) && b.is_a?(Numeric) && g.is_a?(Numeric)

      r = r/256.0 if r > 1.0
      g = g/256.0 if g > 1.0
      b = b/256.0 if b > 1.0

      c_max = [r, g, b].max
      c_min = [r, g, b].min
      delta = c_max - c_min

      h = ( ( (g - b) / delta).to_i % 6.0 ) / 6.0 # if c_max == r
      h = ( ( (b - r) / delta).to_i + 2 ) / 6.0 if c_max == g
      h = ( ( (r - g) / delta).to_i + 4 ) / 6.0 if c_max == b

      s = c_max.zero? ? 0.0 : delta / c_max
      v = c_max

      [h, s, v]
    end

    alias_method :rgb_to_hsv, :to_hsv
  end

  def initialize(tmp_h = nil, tmp_s = nil, tmp_v = nil)
    # Initialize a ColorGenerator object
    # Per http://www.rapidtables.com/convert/color/rgb-to-hsv.htm
    #
    # Example:
    #   > c = ColorGenerator.new
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.1, @s=0.85, @v=0.98>
    #
    # Arguments:
    #   tmp_h, tmp_s, tmp_s: (Numeric; between 0.0 and 1.0, inclusive)

    @h = tmp_h || 0.1
    @s = tmp_s || 0.85
    @v = tmp_v || 0.98

    ensure_valid01(@h, @s, @v)
  end

  def next_color(num = 1)
    # Advance ColorGenerator instance to the next color in its stream.
    # Aliased as ColorGenerator#advance_color and ColorGenerator#advance.
    #
    # Example:
    #   > c = ColorGenerator.new
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.1, @s=0.85, @v=0.98>
    #   > c.to_rgb
    #   => [0.98, 0.6468000000000002, 0.14700000000000002]
    #   > c.to_html_color
    #   => "FAA525"
    #   > c.advance
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.7180339887498953, @s=0.85, @v=0.98>
    #   > c.to_rgb
    #   => [0.4037338757719766, 0.14700000000000002, 0.98]
    #   > c.to_html_color
    #   => "6725FA"
    #
    # Arguments:
    #   num: (optional Integer, defaults to 1)

    return prev_color(num.abs) if num < 0
    return self if num.zero?

    num.times.each { @h = ((@h + golden_ratio_conjugate) % 1.0) }
    ensure_valid01(@h, @s, @v)
    self
  end

  alias_method :advance_color, :next_color
  alias_method :advance, :next_color

  def prev_color(num = 1)
    # Returns ColorGenerator instance to the previous color in its stream.
    #
    # Example:
    #   > c
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.48196601125010474, @s=0.85, @v=0.98>
    #   > c.advance_color
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.10000000000000009, @s=0.85, @v=0.98>
    #   > c.prev_color
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.48196601125010474, @s=0.85, @v=0.98>
    #
    # Arguments:
    #   num: (optional Integer, defaults to 1)

    return next_color(num.abs) if num < 0
    return self if num.zero?

    num.times.each { @h = ((@h + 1.0 - golden_ratio_conjugate) % 1.0) }
    ensure_valid01(@h, @s, @v)
    self
  end

  def to_rgb
    # Presents the state of a ColorGenerator instance as an r,g,b triple
    #
    # Example:
    #   > c
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.48196601125010474, @s=0.85, @v=0.98>
    #   > c.to_rgb
    #   => [0.14700000000000002, 0.98, 0.8898661242280236]
    #
    # Arguments:
    #   none

    h_i = (h*6).to_i
    f = h*6 - h_i
    p = v * (1 - s)
    q = v * (1 - f*s)
    t = v * (1 - (1 - f) * s)
    r, g, b = v, t, p if h_i==0
    r, g, b = q, v, p if h_i==1
    r, g, b = p, v, t if h_i==2
    r, g, b = p, q, v if h_i==3
    r, g, b = t, p, v if h_i==4
    r, g, b = v, p, q if h_i==5

    ensure_valid01(r, g, b)
    [r, g, b]
  end

  def to_html_color
    # Presents the state of a ColorGenerator instance as a string suitable for use in HTML
    #
    # Example:
    #   > c
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.48196601125010474, @s=0.85, @v=0.98>
    #   > c.to_rgb
    #   => [0.14700000000000002, 0.98, 0.8898661242280236]
    #   > c.to_html_color
    #   => "25FAE3"
    #
    # Arguments:
    #   none

    to_rgb.map { |elt| (elt*256).to_i.to_s(16).upcase }.join
  end


  def to_yiq
    # Presents the state of a ColorGenerator instance as a y,i,q triple
    # Per http://www.cs.rit.edu/~ncs/color/t_convert.html#RGB to YIQ & YIQ to RGB
    #
    # Example:
    #   > c
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.48196601125010474, @s=0.85, @v=0.98>
    #   > c.to_rgb
    #   => [0.14700000000000002, 0.98, 0.8898661242280236]
    #   > c.to_yiq
    #   => [0.7206577381619947, -0.4675350258771956, -0.20462763536508466]
    #
    # Arguments:
    #   none

    r, g, b = to_rgb
    y = 0.299 * r + 0.587 * g + 0.114 * b
    i = 0.596 * r - 0.275 * g - 0.321 * b
    q = 0.212 * r - 0.523 * g + 0.311 * b

    ensure_valid01(y, i, q)
    [y, i, q]
  end

  def to_xyz
    # Presents the state of a ColorGenerator instance as a y,i,q triple
    # Per http://www.cs.rit.edu/~ncs/color/t_convert.html
    #
    # Example:
    #   > c
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.48196601125010474, @s=0.85, @v=0.98>
    #   > c.to_rgb
    #   => [0.14700000000000002, 0.98, 0.8898661242280236]
    #   > c.to_xyz
    #   => [0.5716113067315928, 0.7963401853194123, 0.9652260556268222]
    #
    # Arguments:
    #   none

    r, g, b = to_rgb
    x = 0.412453 * r + 0.357580 * g + 0.180423 * b
    y = 0.212671 * r + 0.715160 * g + 0.072169 * b
    z = 0.019334 * r + 0.119193 * g + 0.950227 * b

    ensure_valid01(x, y, z)
    [x, y, z]
  end

  def to_hsv
    # Presents the state of a ColorGenerator instance as a h,s,v triple
    #
    # Example:
    #   > c
    #   => #<ColorGenerator:0x007fcd9f648d08 @h=0.48196601125010474, @s=0.85, @v=0.98>
    #   > c.to_hsv
    #   => [0.48196601125010474, 0.85, 0.98]
    #
    # Arguments:
    #   none

    ensure_valid01(h, s, v)
    [ h, s, v ]
  end

  private

  def ensure_valid01(*vars)
    vars.each do |v|
      fail RunTimeError('Invalid state.') unless v >= 0.0 && v <= 1.0
    end
  end
end
