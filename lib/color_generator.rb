# Derived from work found at http://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/

class ColorGenerator
  attr_accessor :h, :s, :v
  cattr_reader :golden_ratio_conjugate do 0.6180339887498953 end

  # Per http://www.rapidtables.com/convert/color/rgb-to-hsv.htm

  class << self
    def to_hsv(r, g, b)
      r = r.to_i(16).to_s(10).to_i if r.is_a?(String)
      g = g.to_i(16).to_s(10).to_i if g.is_a?(String)
      b = b.to_i(16).to_s(10).to_i if b.is_a?(String)

      r = r/256.0 if r > 1.0
      g = g/256.0 if g > 1.0
      b = b/256.0 if b > 1.0

      c_max = [r, g, b].max
      c_min = [r, g, b].min
      delta = c_max - c_min

      h = ( ( (g - b) / delta).to_i % 6.0 ) / 6.0 # if c_max == r
      h = ( ( (b - r) / delta).to_i + 2 ) / 6.0 if c_max == g
      h = ( ( (r - g) / delta).to_i + 4 ) / 6.0 if c_max == b

      s = c_max.zero? ? 0.0 : delta/c_max
      v = c_max

      [h, s, v]
    end

    alias_method :rgb_to_hsv, :to_hsv
  end

  def initialize(tmp_h = nil, tmp_s = nil, tmp_v = nil)
    @h = tmp_h || 0.1
    @s = tmp_s || 0.85
    @v = tmp_v || 0.98
  end

  def next_color(num = 1)
    return prev_color(num.abs) if num < 0
    return self if num.zero?

    num.times.each { @h = ((@h + golden_ratio_conjugate) % 1.0) }
    self
  end

  alias_method :advance_color, :next_color
  alias_method :advance, :next_color

  def prev_color(num = 1)
    return next_color(num.abs) if num < 0
    return self if num.zero?

    num.times.each { @h = ((@h + 1.0 - golden_ratio_conjugate) % 1.0) }
    self
  end

  def to_rgb
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
    [r, g, b]
  end

  def to_html_color
    to_rgb.map { |elt| (elt*256).to_i.to_s(16).upcase }.join
  end

  # Per http://www.cs.rit.edu/~ncs/color/t_convert.html#RGB to YIQ & YIQ to RGB

  def to_yiq
    r, g, b = to_rgb
    y = 0.299 * r + 0.587 * g + 0.114 * b
    i = 0.596 * r - 0.275 * g - 0.321 * b
    q = 0.212 * r - 0.523 * g + 0.311 * b
    [y, i, q]
  end

  # Per http://www.cs.rit.edu/~ncs/color/t_convert.html#RGB to YIQ & YIQ to RGB

  def to_xyz
    r, g, b = to_rgb
    x = 0.412453 * r + 0.357580 * g + 0.180423 * b
    y = 0.212671 * r + 0.715160 * g + 0.072169 * b
    z = 0.019334 * r + 0.119193 * g + 0.950227 * b
    [x, y, z]
  end

  def to_hsv
    [ h, s, v ]
  end
end
