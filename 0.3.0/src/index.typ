#import "div.typ": div, clsx, nd, shape
#import "ao.typ": *
#import "base.typ": *
#import "layout.typ": *
#import "is.typ": *
#import "components.typ": *
#import "staging.typ": *
#import "patterns.typ"
#import "strokes.typ"
#import "colors.typ"
#import "string.typ"
#import "typst.typ"
#import "constants.typ": *
// #import "colors.typ": color-pair

#let markup(s) = {
  if is-content(s) {
    s
  } else {
    eval(s, mode: "markup")
  }
}

#let stroked(..args) = {
  let dash-patterns = (
  solid: "solid",
  dotted: "dotted",
  dashed: "dashed",
  dash-dotted: "dash-dotted",
  dd: "densely-dotted",
  ddd: "densely-dash-dotted",
  loosely-dotted: "loosely-dotted",
  loosely-dashed: "loosely-dashed",
  loosely-dash-dotted: "loosely-dash-dotted",
    )

  let (paint, thickness, dash) = (none, none, none)
  for arg in args.pos() {
    if type(arg) == length {
      thickness = arg
    } else if type(arg) == str {
      dash = dash-patterns.at(arg)
    } else {
      paint = arg
    }
  }

  let result = (:)
  if paint != none {
    result.insert("paint", paint)
  }
  if thickness != none {
    result.insert("thickness", thickness)
  }
  if dash != none {
    result.insert("dash", dash)
  }

  return result
}


#let dataload(name) = {
    let is-yml = name.ends-with("yml")
    let func = tern(is-yml, yaml, json)
    let base = "/home/kdog3682/.kdog3682/typst-data/"
    let path = base + name
    return func(path)
}
// #dataload("hi")
