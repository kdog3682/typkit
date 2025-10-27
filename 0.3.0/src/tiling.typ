// Helper to normalize size parameter
#let normalize-size(size) = {
  if type(size) == array {
    size
  } else {
    (size, size)
  }
}

#let checkerboard(
  size: 20pt,
  fg: black,
  bg: white,
) = {
  let (w, h) = normalize-size(size)
  let r = rect.with(width: w / 2, height: h / 2)
  return pattern(
    size: (w, h),
    {
      block(
        {
          place(r(fill: fg), top + left)
          place(r(fill: bg), top + right)
          place(r(fill: bg), bottom + left)
          place(r(fill: fg), bottom + right)
        },
        width: w,
        height: h,
      )
    },
  )
}

#let stripes(
  mode: "horizontal",
  thickness: 0.25pt,
  paint: black,
  spacing: 5pt,
  bg: none,
) = {
  let (w, h) = normalize-size(spacing)
  let l = line.with(stroke: (thickness: thickness, paint: paint))
  return pattern(
    size: (w, h),
    {
      block(
        {
          if bg != none {
            place(rect(width: w, height: h, fill: bg, stroke: none))
          }
          if mode == "horizontal" {
            place(l(start: (0%, 100%), end: (100%, 100%)))
          } else if mode == "vertical" {
            place(l(start: (0%, 0%), end: (0%, 100%)))
          } else if mode == "diagonal" {
            place(l(start: (0%, 0%), end: (100%, 100%)))
          } else if mode == "anti-diagonal" {
            place(l(start: (0%, 100%), end: (100%, 0%)))
          } else if mode == "criss-cross" {
            place(l(start: (0%, 0%), end: (100%, 100%)))
            place(l(start: (0%, 100%), end: (100%, 0%)))
          }
        },
        width: w,
        height: h,
      )
    },
  )
}

#let polka-dots(
  radius: 1pt,
  spacing: 8pt,
  fg: black,
  bg: none,
) = {
  let (w, h) = normalize-size(spacing)
  return pattern(
    size: (w, h),
    {
      block(
        {
          if bg != none {
            place(rect(width: w, height: h, fill: bg, stroke: none))
          }
          place(
            circle(radius: radius, fill: fg, stroke: none),
            center + horizon,
          )
        },
        width: w,
        height: h,
      )
    },
  )
}

// Pattern presets
#let cross-hatch = stripes.with(
  mode: "criss-cross",
  thickness: 0.25pt,
  paint: black,
  spacing: 5pt,
)

#let horizontal-lines = stripes.with(
  mode: "horizontal",
  thickness: 0.25pt,
  paint: black,
  spacing: 5pt,
)

#let vertical-lines = stripes.with(
  mode: "vertical",
  thickness: 0.25pt,
  paint: black,
  spacing: 5pt,
)

#let diagonal-lines = stripes.with(
  mode: "diagonal",
  thickness: 0.25pt,
  paint: black,
  spacing: 5pt,
)

#let anti-diagonal-lines = stripes.with(
  mode: "anti-diagonal",
  thickness: 0.25pt,
  paint: black,
  spacing: 5pt,
)

#let dots = polka-dots.with(
  radius: 1pt,
  spacing: 8pt,
  fg: black,
)

// Examples

// #let sample-rect = rect.with(
//   width: 50pt,
//   height: 50pt,
//   stroke: black,
// )

// #let fills = (
//   checkerboard(),
//   horizontal-lines(),
//   vertical-lines(),
//   diagonal-lines(),
//   anti-diagonal-lines(),
//   cross-hatch(),
//   dots(),
//   checkerboard(fg: red, bg: yellow),
// )
//
// #grid(
//   columns: 4,
//   gutter: 15pt,
//   ..fills.map(fill => sample-rect(fill: fill))
// )
