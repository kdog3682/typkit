// #import "div.typ": div, clsx, nd, shape
#import "div.typ": *
#import "ao.typ": *
#import "base.typ": *
#import "layout.typ": *
#import "is.typ": *
#import "star.typ": *
// #import "grid.typ": *
#import "components.typ": *
#import "staging.typ": *
#import "pytypst-adapter.typ": *
#import "patterns.typ"
#import "strokes.typ"
#import "font.typ"
#import "colors.typ"
#import "tiling.typ"
#import "string.typ": *
#import "string.typ"
#import "my.typ"
#import "typst.typ"
// #import "templates.typ"
#import "constants.typ"

#import "resolve.typ": *
#import "new.typ": *
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
  for i in range(n) {
    store.push(fn(i))
  }
  return store
}

#let dots(n, fill: black, radius: 0.5pt) = {
  flex(each(n, x => circle(fill: fill, radius: radius)), spacing: radius * 2)
}


#let space-wrap(value, before: none, after: none, dir: h) = {
  if exists(before) {
    dir(resolve-point(before))
  }
  value
  if exists(after) {
    dir(resolve-point(after))
  }
}
#let CHINESE-FONT = "Noto Serif CJK SC"


#let up(el, n) = {
  if n == 0 {
    el
  } else {
    box(el, baseline: -1pt * n)
  }
}

#let rec(..sink, k: 10) = {
  let args = sink.pos()
  let length = args.len()
  let (width, height, color) = if length == 3 {
    args
  } else if length == 2 {
    args + (blue,)
  } else {
    (args.first(), args.first(), blue)
  }
  let width = resolve-point(width) * k
  let height = resolve-point(height) * k
  box(rect(width: width, height: height, fill: color))
}


#let square(..sink) = {
  let args = sink.pos()
  let (size, color) = if args.len() == 2 {
    args
  } else {
    (args.first(), blue)
  }
  let size = resolve-point(size)
  box(rect(width: size, height: size, fill: color))
}

#let multiply(content, n) = {
  (content,) * n
}


/// given a sink argument ... normalizes the sink into a flat array for table() consumption.
#let normalize-table-items(sink) = {

  let pos = sink.pos()
  return if pos.len() == 2 {
    array.zip(..pos).flatten()
  } else {
    let arg = pos.first()
    if is-nested-array(arg) {
      arg.flatten()
    } else {
      pos
    }
  }
}


#let assert-existance(s) = {
  assert(s != none, message: "a value is required ... the value is none")
}
#let shift(el, up: none, down: none, left: none, right: none) = {

  let vertical-shift(el, n) = {
    if n == 0 {
      el
    } else {
      box(el, baseline: n)
    }
  }


  let up = resolve-point(up)
  let down = resolve-point(down)
  let right = resolve-point(right)
  let left = resolve-point(left)
  let c = el
  if up != none {
    c = vertical-shift(c, -1 * up)
  }
  if down != none {
    c = vertical-shift(c, down)
  }

  if left != none {
    c = {
      h(left)
      c
    }
  }

  if right != none {
    c = {
      c
      h(right)
    }
  }

  c
}



