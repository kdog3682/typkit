#let pattern = tiling
#let criss-cross = pattern(
  size: (3pt, 3pt),
  {
    place(
      line(
        start: (0%, 0%),
        end: (100%, 100%),
      ),
    )
    place(
      line(
        start: (0%, 100%),
        end: (100%, 0%),
      ),
    )
  },
)

#let dots = pattern(
  size: (10pt, 10pt),
  {
    circle(
      fill: black,
      radius: 0.5pt,
    )
  },
)

#let stripes() = {
  let pat = pattern(
    size: (10pt, 10pt),
    place(
      line(
        start: (0%, 0%),
        end: (100%, 100%),
        stroke: 0.5pt,
      ),
    ),
  )
  return pat
}

#let cross = pattern(
  size: (3pt, 6pt),
  {
    place(
      line(
        start: (0%, 0%),
        end: (100%, 100%),
      ),
    )
    place(
      line(
        start: (0%, 100%),
        end: (100%, 0%),
      ),
    )
  },
)

#let circles = pattern(
  size: (3pt, 3pt),
  {
    circle(radius: 1pt, fill: gray)
  },
)

#let small-dots = pattern(
  size: (5pt, 5pt),
  {
    place(
      circle(
        fill: black.lighten(85%),
        radius: 0.5pt,
      ),
      dx: 1.5pt,
      dy: 1.5pt,
    )
  },
)


#let criss-crossed(size: 5pt, fill: blue) = {

  return pattern(
    size: (size, size),
    {
      place(
        line(
          start: (0%, 0%),
          end: (100%, 100%),
          stroke: fill,
        ),
      )
      place(
        line(
          start: (0%, 100%),
          end: (100%, 0%),
          stroke: fill,
        ),
      )
    },
  )
}


#let polka-dotted(size: 1pt, fill: blue) = {
  let circles = pattern(
    size: (3pt, 3pt),
    {
      circle(radius: size, fill: fill)
    },
  )
  return circles
}
