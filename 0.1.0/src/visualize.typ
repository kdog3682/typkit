#import "@preview/cetz:0.2.2"
#import "is.typ": *
#import "misc.typ": *
#import "math.typ": *

#let content-point((a, b), ..style) = {
    box([(*#a*, *#b*)], fill: white, inset: 3pt, ..style)
}

#let rel(pos, x, y) = {
    (rel: (x, y), to: pos)
}
#let master = (
    "east": (
        anchor: "west",
        offset: 0.5,
    ),
    "west": (
        anchor: "east",
        offset: -0.5,
    ),
    "origin": (
        anchor: "south-west",
        offset: 0.5,
    )
)


#let point(i, fn, label: none) = {
    let black-circle-style = (radius: 5pt, fill: black)
    let y = if is-function(fn) { fn(i) } else { fn }
    let p = (i, y)
    cetz.draw.circle(p, ..black-circle-style)

    if exists(label) {
        let s = content-point(p)
        let sign = magnitude(i)
        let key = tern(sign == -1, "west", "east")
        let ( anchor, offset ) = master.at(key)
        let y-offset = if y == 0 {
            offset
        } else {
            0
        }
        cetz.draw.content(rel(p, offset, y-offset), s, anchor: anchor)
    }
}

