#import "@preview/cetz:0.2.2"
#import "resolve.typ": *
#import "formulas.typ": *


#let canvas = cetz.canvas

#let points(points, ..sink) = {
    for p in points {
      cetz.draw.circle(p, radius: 0.2, stroke: none, fill: black, ..sink)
    }
}

#let polygon(points, ..sink) = {
    cetz.draw.line(..points, close: true, ..sink)
}



#let get-brace-content-angle(p1, p2) = {
  let angle = get-angle-between-points(p1, p2) - 90deg
  if angle < -180deg {
    angle += 180deg
  }
  return angle
}



#let brace(a, b, ..sink) = {
    cetz.decorations.brace(a, b, name: "brace", ..sink)
    cetz.draw.content("brace.k", resolve-math-content(c))

    cetz.decorations.brace(a, b, flip: true, name: "brace", ..brace-attrs)
  if content != none and rotate-content == true {
      let angle = get-brace-content-angle(m1, m2)
      content = typst.rotate(content, angle)
  }
  // 
}

#let rect(..sink) = {
    let args = sink.pos()
    let kwargs = sink.named()
    let l = args.len()
    if l == 4 {
        args = args.chunks(2)
        cetz.draw.rect(..args, ..kwargs)
    }
    else if l == 5 {
        let c = args.pop()
        // panic(c)
        args = args.chunks(2)
        cetz.draw.rect(..args, ..kwargs)
        let center = midpoint(..args)
        // panic(center)
        cetz.draw.content(center, c)
    }
}


#let content(..sink) = {
    let args = sink.pos()
    let kwargs = sink.named()
    if args.len() == 3 {
        return cetz.draw.content(args.slice(0, 2), args.at(2), ..kwargs)
    } else {
        return cetz.draw.rect(..args, ..kwargs)
    }
}


#let square(p1, ..sink) = {
    let args = sinks.pos()
    let c = if args.len() == 1 {
        args.at(0)
    } else {
        none
    }

    let kwargs = sink.named()
    let length = kwargs.at("length", default: 1)
    let p2 = (p1.at(0) + length, p1.at(1) + length)
    let attrs = build-attrs((:), sink, key: "rect")
    cetz.draw.rect(p1, p2, ..attrs)
}

#let brace-effect(shape, value, pos: "top") = {
    return 
}

// Explore ~/github
// Explore ~/2024-javascript/staging

// #panic(points((1,1), stroke:green))
