#import "base.typ": arrow
#import "colors.typ"


#let ARROW = arrow(10pt)
#let EMDASH = sym.dash.em

#let ROYGBIV = (
  red,
  orange,
  yellow,
  green,
  blue,
  blue,
  purple,
)

#let ROYGBIV = colors.pallete-fun

#let ok(lightness, chroma, hue, alpha) = {
  oklch(lightness * 5%, chroma * 5%, hue * 10deg, alpha * 10%)
}

#let ROYGBIV9 = (
    ok(18, 18, 38, 9), // maroon / red
    ok(20, 15, 41, 10), // orange
    ok(20, 15, 9, 10), // light-yellow
    ok(20, 12, 52, 10), // teal (light-green)
    ok(16, 20, 87, 10), // green
    ok(20, 15, 27, 9), // bubble-gum-blue
    ok(13, 15, 21, 10), // blue
    ok(20, 15, 0, 10), // light-purple
    ok(20, 21, 1, 10), // darker purple
)

#let OPERATORS = (
    "pi": sym.pi,
    "+": sym.plus,
    "-": sym.minus,
    "*": sym.ast,
    "/": sym.slash,
    "%": sym.percent,
    "==": sym.eq,
)

