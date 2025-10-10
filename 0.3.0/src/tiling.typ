// Helper to normalize size parameter
#let normalize-size(size) = {
  if type(size) == array {
    size
  } else {
    (size, size)
  }
}

// Criss-cross tiling pattern
#let criss-cross(
  size: 10pt,
  stroke: 1pt + black,
) = {
  let size = normalize-size(size)
  tiling(
    size: size,
    {
      place(line(start: (0%, 0%), end: (100%, 100%), stroke: stroke))
      place(line(start: (0%, 100%), end: (100%, 0%), stroke: stroke))
    },
  )
}

// Checkerboard tiling pattern
#let checkerboard(
  size: 10pt,
  fg: black,
  bg: white,
) = {
  let size = normalize-size(size)
  tiling(
    size: size,
    {
      place(rect(width: 50%, height: 50%, fill: bg))
      place(dx: 50%, rect(width: 50%, height: 50%, fill: fg))
      place(dy: 50%, rect(width: 50%, height: 50%, fill: fg))
      place(dx: 50%, dy: 50%, rect(width: 50%, height: 50%, fill: bg))
    },
  )
}

// Diagonal stripes pattern
#let diagonal-stripes(
  size: 10pt,
  stroke: 2pt + black,
) = {
  let size = normalize-size(size)
  tiling(
    size: size,
    {
      place(line(start: (0%, 0%), end: (100%, 100%), stroke: stroke))
    },
  )
}

// Grid pattern
#let grid-pattern(
  size: 10pt,
  stroke: 1pt + black,
) = {
  let size = normalize-size(size)
  tiling(
    size: size,
    {
      place(line(start: (0%, 0%), end: (100%, 0%), stroke: stroke))
      place(line(start: (0%, 0%), end: (0%, 100%), stroke: stroke))
    },
  )
}

// Dots pattern
#let dots(
  size: 10pt,
  radius: 3pt,
  fill: black,
) = {
  let size = normalize-size(size)
  tiling(
    size: size,
    {
      place(dx: 50%, dy: 50%, circle(radius: radius, fill: fill))
    },
  )
}

// Horizontal stripes pattern
#let horizontal-stripes(
  size: 10pt,
  fg: black,
  bg: white,
) = {
  let size = normalize-size(size)
  tiling(
    size: size,
    {
      place(rect(width: 100%, height: 50%, fill: bg))
      place(dy: 50%, rect(width: 100%, height: 50%, fill: fg))
    },
  )
}

// Vertical stripes pattern
#let vertical-stripes(
  size: 10pt,
  fg: black,
  bg: white,
) = {
  let size = normalize-size(size)
  tiling(
    size: size,
    {
      place(rect(width: 50%, height: 100%, fill: bg))
      place(dx: 50%, rect(width: 50%, height: 100%, fill: fg))
    },
  )
}
