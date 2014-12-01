color_generator
===============

Programmatic generation of reproducible, pseudo-random stream of colors


#### What's this?

As Martin Ankerl stated very well in his blog post at http://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/ , there are occasionally times that one
might need to programmatically generate an unknown number of colors that are ``aesthetically
pleasing'' or ``compatible'' in some sense in a very small amount of code.
This library is intended to provide this sort of mechanism, using a pattern akin to a
pseudo-random number generator: starting with a user-definable seed value (that maps to a color),
the step through an abitrary sequence of colors.  Colors are natively stored using HSV values
per the explanation in the previously given post, and may be converted or presented in several
other different forms.  Multiple streams may be used concurrently and independently of each other.

## Installation

``` {.example}
gem install color_generator
```

## Usage

```ruby
require 'color_generator'

> c = ColorGenerator::Generator.new     # => #<ColorGenerator:0x007f96efbb5570 @h=0.1, @s=0.85, @v=0.98>
> c.next_color                          # => #<ColorGenerator:0x007f96efbb5570 @h=0.7180339887498953, @s=0.85, @v=0.98>
> c.to_html_color                       # => "6725FA"
> c.advance                             # => #<ColorGenerator:0x007f96efbb5570 @h=0.3360679774997908, @s=0.85, @v=0.98>
> c.to_html_color                       # => "25FA29"
> c.advance(-1)                         # => #<ColorGenerator:0x007f96efbb5570 @h=0.7180339887498954, @s=0.85, @v=0.98>
> c.to_html_color                       # => "6725FA"
> c.to_rgb                              # => [0.4037338757719774, 0.14700000000000002, 0.98]

## Contributing

Feel free to fork, branch, open an issue ticket if you find something that could be improved, etc.

## Acknowledgements

Copyright [Bill McKinnon](http://www.bmck.org), released under the GPLv2 License.