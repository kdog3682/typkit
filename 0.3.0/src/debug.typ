#import "constants.typ"
#import "strokes.typ"
#import "resolve.typ": resolve-point
#import "layout.typ": flex
#import "div.typ": div
#import "layout.typ": flex
#import "resolve.typ": resolve-point 

#let dots(n, fill: black, radius: 0.5pt) = {
  flex(each(n, x => circle(fill: fill, radius: radius)), spacing: radius * 2)
}

#let colors = (red, blue, green, orange, purple, teal, maroon, olive, navy, fuchsia)
#let rect-counter = counter("rect-factory")

#let rect(..args) = {
  let p = args.pos()
  let w = resolve-point(p.at(0, default: 20pt))
  let h = resolve-point(p.at(1, default: 20pt))
  rect-counter.step()
  context {
    let n = rect-counter.get().first()
    let label = str.from-unicode(64 + n)
    let color = colors.at(calc.rem(n - 1, colors.len()))
    box(
      width: w,
      height: h,
      fill: color.lighten(60%),
      stroke: color,
      align(center + horizon, text(fill: color.darken(20%), weight: "bold", label))
    )
  }
}

