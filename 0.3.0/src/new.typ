#import "constants.typ"
#import "strokes.typ"
#import "layout.typ": flex
#import "div.typ": div

#let parse-rects(s, k: 10) = {
  let colors = constants.ROYGBIV9
  let r = if "," in s {
    regex("(-?\\d+)\\s*,\\s*(-?\\d+)")
  } // else if "[" in s {
   //   regex("\\[(\\d+(?:\.\d+)?)\\s*,\\s*(\\d+(?:\.\d+)?)\\]")
   // }
  else {
    regex("(\\d(?:\.\d)?)(\\d(?:\.\d)?)")
  }
  let coords = s.matches(r).map(m => (float(m.captures.at(0)), float(m.captures.at(1))))
  return coords.enumerate().map(((i, x)) => rec(..x, colors.at(i), k: k))
}


#let flex-wrap(items, spacing: 5pt, width: 150pt) = {
  block(items.join(h(spacing)), width: width)
}

#let opposite(x) = {
  if x == ltr {
    return ttb
  }
  if x == ttb {
    return ltr
  }
}

#let indent(x, ind: 10pt) = {
  pad(x, left: ind)
}
#let view(x) = {
  scale(x, 45%, reflow: true)
}





#let insetf(inset) = {
  let inset-func(col, row) = {
    // spacing between the first and 2nd row
    if row == 0 {
      (bottom: inset)
    } else if row == 1 {
      (top: inset)
    } else {
      (:)
    }
  }
  return inset-func
}


#let v-separator(a, b, padding: 10pt) = {
  let header = grid(a, b, align: center, grid.hline(y: 1, stroke: 0.5pt), inset: insetf(padding),)
  header
}


#let copyright(s) = {
  flex(sym.copyright, s, spacing: 2pt)
}



#let dinkus() = {
  return (
    sym.tilde,
    sym.diamond.medium.filled,
    sym.tilde,
  ).join(h(5pt))
}
#let h1(..pieces, size: "h1", underline: false, centered: false) = {
  let heading-sizes = (
    "h1": 24pt,
    "h2": 18pt,
    "h3": 14pt,
    "h4": 12pt,
    "h5": 10pt,
    "h6": 8pt,
  )


  let contents = pieces.pos()
  let s = contents.map(text).join(h(2pt))
  let size = if type(size) == str {
    heading-sizes.at(size)
  } else {
    size
  }
  set text(size: size, weight: "bold")

  if centered == true {
    s = align(s, center)
  }
  s
  if underline == true {
    v(-0.8em)
    line(length: 100%, stroke: strokes.thin)
  }
}


#let collect(doc) = {
  let store = ()
  for child in doc.fields().children {
    let fields = child.fields()
    let body = fields.at("body", default: none)
    if body != none {
      store.push(body)
    }
  }
  return store
}
#let numbered(items, wrapper) = {
  return items
    .enumerate(start: 1)
    .map(((n, el)) => {
      return wrapper(n, el)
    })
}


#let fit(el, base: 200pt, delta: 75pt) = context {
  let b1 = block(el, width: base)
  let m1 = measure(b1)
  let h1 = m1.height
  let w1 = m1.width

  let b2 = block(el, width: base + delta)
  let m2 = measure(b2)
  let h2 = m2.height
  let w2 = m2.width

  if h2 < h1 {
    return b2
  } else {
    return b1
  }
}



#let quote(s) = {
  set text(style: "italic")
  set par(spacing: 8pt)
  s
}

#let space-sandwich(s, spacing: 20pt, indent: none, centered: false) = {
  v(spacing)

  if indent != none {
    pad(left: indent, s)
  } else if centered != false {
    align(s, center)
  } else {
    s
  }
  v(spacing)
}


#let hr(..sink, above: 0, below: 0, length: 100%, symbol: none) = {
  let ref = ("diamond": sym.diamond.small.filled)
  let c = if symbol != none {
    return align(ref.at(symbol), center)
  } else {
    let stroke = sink.pos().first()
    line(length: length, stroke: stroke)
  }
  space-wrap(c, before: above, after: below, dir: v)
}


#let display-link = div.with(underline: true, italic: true, size: 0.9em)





#let get-dinkus() = {
  let tilde = move(sym.tilde, dy: 1pt)
  let diamond = scale(sym.diamond.filled, 95%)
  tk.centered(tk.flex(tilde, diamond, tilde, spacing: 6pt))
}



