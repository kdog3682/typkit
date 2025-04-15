#import "div.typ": div
#let ok(lightness, chroma, hue, alpha) = {
  oklch(lightness * 5%, chroma * 5%, hue * 10deg, alpha * 10%)
}
#let bok(lightness, chroma, hue, alpha) = {
  div(wh: 25pt, bg: ok(lightness, chroma, hue, alpha))
}
#let pallete-fun = (

ok(18, 18, 38, 9), // maroon
ok(20, 15, 41, 10), // orange
ok(20, 15, 9, 10), // light-yellow
ok(20, 15, 52, 10), // teal
ok(20, 15, 27, 9), // bubble-gum-blue
ok(20, 15, 0, 10), // light-purple
ok(13, 15, 21, 10), // blue
)

#let native = div.with(wh: 25pt)

#let roygbiv = (
  red,
  orange,
  yellow,
  green,
  blue,
  blue,
  purple,
)
// #flex(roygbiv.map(x => native(fill: x)))
// #flex(my-colors.map(x => native(fill: x)))

#let palettes = (
    fun: pallete-fun
)
#let silver = silver.lighten(75%)
