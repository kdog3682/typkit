
#let rounded-star(
  center: (0, 0),
  r-outer: 80,
  r-inner: 35,
  points: 5,
  corner-radius: 12,
  roundness: 0.5,  // 0 = pointier corners, 1 = very round
  fill: blue,
  stroke: black,
) = {
  // let curve = path
  let cx = center.at(0)
  let cy = center.at(1)
  let pi = calc.pi
  let min = calc.min
  let max = calc.max
  let cos = calc.cos
  let sin = calc.sin
  let sqrt = calc.sqrt
  let n = points * 2
  let ang0 = -pi / 2
  let dtheta = pi / points

  // Alternating outer/inner star vertices
  let verts = range(0, n).map(i => {
    let r = if calc.rem(i, 2) == 0 {
      r-outer
    } else {
      r-inner
    }
    let a = ang0 + i * dtheta
    (cx + r * cos(a), cy + r * sin(a))
  })

  let hypot = (x, y) => sqrt(x * x + y * y)
  let norm = (x, y) => {
    let l = hypot(x, y)
    (x / l, y / l)
  }

  // For each corner: (S, C1, C2, E)
  let segs = range(0, n).map(i => {
    let pprev = verts.at(calc.rem(i - 1 + n, n))
    let pc = verts.at(i)
    let pnext = verts.at(calc.rem((i + 1), n))

    let v_in = (pc.at(0) - pprev.at(0), pc.at(1) - pprev.at(1))
    let v_out = (pnext.at(0) - pc.at(0), pnext.at(1) - pc.at(1))

    let lin = hypot(v_in.at(0), v_in.at(1))
    let lout = hypot(v_out.at(0), v_out.at(1))

    let u_in = norm(v_in.at(0), v_in.at(1))
    let u_out = norm(v_out.at(0), v_out.at(1))

    let d = min(corner-radius, 0.5 * min(lin, lout))

    let S = (pc.at(0) - u_in.at(0) * d, pc.at(1) - u_in.at(1) * d)
    let E = (pc.at(0) + u_out.at(0) * d, pc.at(1) + u_out.at(1) * d)

    let C1 = (
      S.at(0) + (pc.at(0) - S.at(0)) * roundness,
      S.at(1) + (pc.at(1) - S.at(1)) * roundness,
    )
    let C2 = (
      E.at(0) + (pc.at(0) - E.at(0)) * roundness,
      E.at(1) + (pc.at(1) - E.at(1)) * roundness,
    )

    (S, C1, C2, E)
  })

  let lastE = segs.at(n - 1).at(3)


  let pieces = ()
  pieces.push(curve.move(lastE))

  // straight edge to each corner start (S), then rounded corner (cubic to E)
  for seg in segs {
    let a = curve.line(seg.at(0))
    let b = curve.cubic(seg.at(1), seg.at(2), seg.at(3))
    pieces.push(a)
    pieces.push(b)
  }

  pieces.push(curve.close())
  curve(
    fill: fill,
    stroke: stroke,
    ..pieces,
  )
}

// #rounded-star()


#import "@preview/cetz:0.3.2"
#let star(n: 5, inner-radius: none, radius: 1, start: 90deg, content: none, ..style) = {
  // Resolve the current style ("star")
  // Compute the corner coordinates
  if inner-radius == none {
  inner-radius = radius / 2
  }
  let center = (0, 0)
  let corners = range(0, n * 2).map(i => {
    let a = start + i * 360deg / (n * 2)
    let r = if calc.rem(i, 2) == 0 {
      radius
    } else {
      inner-radius
    }
    // Output a center relative coordinate
    (rel: (calc.cos(a) * r, calc.sin(a) * r, 0), to: center)
  })
  cetz.canvas({
    cetz.draw.line(..corners, ..style, close: true)
    if content != none {
    cetz.draw.content(center, content)
    }
  })
}
