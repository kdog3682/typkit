// #import "div.typ": div, clsx, nd, shape
#import "div.typ": *
#import "ao.typ": *
#import "base.typ": *
#import "layout.typ": *
#import "is.typ": *
#import "components.typ": *
#import "staging.typ": *
#import "patterns.typ"
#import "strokes.typ"
#import "font.typ"
#import "colors.typ"
#import "string.typ"
#import "typst.typ"
#import "templates.typ"
#import "constants.typ": *
#import "resolve.typ": *
// #import "colors.typ": color-pair

#let markup(s) = {
  if is-content(s) {
    s
  } else {
    eval(str(s), mode: "markup")
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



#let placed(point, content) = {
  let (dx, dy) = point
  place(
    dx: resolve-point(dx),
    dy: resolve-point(dy),
    content,
  )
}

#let polygon-from-path(points, fill: none, stroke: black) = {
  path(..points.map(pair => pair.map(resolve-point)), fill: fill, stroke: stroke, closed: true)
}

#let mapped(func, k: 1) = {
  return x => x.map(func.with(k))
}

#let centered(content) = {
  return align(content, center + horizon)
}


#let o-table(objects) = {
  let keys = objects.first().keys()
  let store = objects.map(x => x.values()).flatten()
  show table.cell.where(y: 0): strong
  table(
    columns: (60pt,) * keys.len(),
    align: center + horizon,
    table.header(..keys),
    ..store
  )
}


#let chinese(key) = {
  return read-data("data/chinese.yml").at(key)
}



#let preview-frame(content) = {
  set page(margin: 5pt)
  let r = rect(
    width: 5in,
    height: 50%,
    // height: 5.25in,
    stroke: 0.5pt + black,
    inset: 0.5in,
    radius: 5pt,
    content,
  )
  move(scale(r, 65%), dx: -50pt, dy: -50pt)
}

#let n2char(i) = {
  return "ABCDEFGHIJKLMNOPQRSTUVWXYZ".at(i)
}



#let stylesheet = yaml("data/stylesheet.yml")
#let title(s, style: "default") = {
  div(
    s,
    class: stylesheet.title.at(style),
  )
}
#let qnum(s, style: "default") = {
  div(
    s,
    class: stylesheet.qnum.at(style),
  )
}
#let repeat(el, count: 6) = {
    let store = ()
    for i in range(count) {
        if type(el) == content {
            store.push(el)
        } else {
            store.push(el())
        }
    }
    return store
}



#let each(n, fn) = {
    let store = ()
    for i in range(n){
        store.push(fn(i))
    }
    return store
}

#let dots(n, fill: black, radius: 0.5pt) = {
    flex(each(n, x => circle(fill: fill, radius: radius)), spacing: radius * 2)
}
