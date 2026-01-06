// #import "div.typ": div, clsx, nd, shape
#import "div.typ": *
#import "ao.typ": *
#import "base.typ": *
#import "layout.typ": *
#import "is.typ": *
#import "star.typ": *
// #import "grid.typ": *
// #import "components.typ": *
#import "components/index.typ" as components
#import "staging.typ": *
#import "pytypst-adapter.typ": *
#import "patterns.typ"
#import "strokes.typ"
#import "font.typ"
#import "colors.typ"
#import "debug.typ"
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

#let point-to-float(point) = {
  return float(repr(point).replace("pt", ""))
}


#let stroked(..args) = {
  let dash-patterns = (
    solid: "solid",
    dotted: "dotted",
    dashed: "dashed",
    dash-dotted: "dash-dotted",
    dd: "densely-dotted",
    dash: "densely-dotted",
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


#let show-as-content(x) = {
    if type(x) == content {
      return x
    }
    if type(x) == str {
      return x
    }
    return repr(x)
}
#let o-table(objects, columns: none, align: center + horizon, inset: 5pt) = {
  let keys = objects.first().keys()
  let store = objects.map(x => x.values().map(show-as-content)).flatten()
  show table.cell.where(y: 0): strong
  table(
    columns: if columns != none {columns} else {(60pt,) * keys.len()},
    align: align,
    inset: inset,
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
#let resolve-dot-dict(dict, key) = {
  let parts = key.split(".")
  let val = dict
  let path = ()
  for p in parts {
    if type(val) != dictionary {
      panic("Cannot access '" + p + "' on non-dictionary at '" + path.join(".") + "'")
    }
    if p not in val {
      let loc = if path.len() == 0 { "root" } else { "'" + path.join(".") + "'" }
      panic("Key '" + p + "' not found at " + loc)
    }
    val = val.at(p)
    path.push(p)
  }
  val
}
#let styled(content, key) = {
  div(content, class: resolve-dot-dict(stylesheet, key))
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





#let measured(input) = context {
    let content = show-as-content(input)
    let m = measure(content)
    table(content, repr(m), columns: 2, inset: 10pt)
}
