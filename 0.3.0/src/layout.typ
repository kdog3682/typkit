#import "ao.typ": merge-attrs, filter-none, to-array, mapfilter, partition
#import "is.typ": is-number, is-length
#let flex(
  spacing: 5pt,
  dir: ltr,
  centered: true,
  ..sink,
) = {
  let horizontal = dir == ltr
  let base = if sink.pos().len() == 1 {
    to-array(sink.pos().first())
  } else {
    sink.pos()
  }
  let items = filter-none(base)
  if items.len() <= 1 {
    return items.join()
  }

  let (align, columns) = if horizontal == true {
    if centered == true {
    (horizon, items.len())
    } else {

    (top, items.len())
    }
  } else {
    if centered == true {
        (center, 1)
    } else  {
        (left, 1)
    }

  }
  grid(
    ..items, columns: columns, gutter: spacing,
    align: align,
  )
}



// creates an inner grid with lines radiating outwards.
// there is no border
#let inner-grid(
  items,
  columns: 3,
  stroke: 0.25pt,
) = {
  let rows = int(items.len() / columns)
  set table(
    stroke: (x, y) => (
      left: if x > 0 {
        stroke
      },
      top: if y > 0 {
        stroke
      },
    ),
    columns: (1fr,) * columns,
    inset: 0pt,
    rows: (1fr,) * rows,
  )

  table(..items)
}





#let stack-callback(el, v) = {
  if el == none {
    return
  }
  if is-number(el) {
    return v(el * 1pt)
  }
  if is-length(el) {
    return v(el)
  }
  return el
}
#let v-stack(..sink, spacing: 0pt) = {
  let items = mapfilter(sink.pos(), x => stack-callback(x, v))
  return stack(..items, spacing: spacing)
}


#let h-stack(..sink, spacing: 0pt) = {
  let items = mapfilter(sink.pos(), x => stack-callback(x, h))
  return stack(..items, spacing: spacing, dir: ltr)
}

#let apart(..sink) = {
  let args = sink.pos()
  let l = args.len()
  if l == 2 {
    let (a, b) = args
    if b == none {
      return align(a, left)
    } else if a == none {
      return align(b, right)
    } else {
      return stack(a, h(1fr), b, dir: ltr)
    }
  } else if l == 3 {
    let (a, b, c) = args
    if a == none and c == none {
      return align(b, center)
    }
    
    // Handle all possible combinations for 3 arguments
    if a == none and b == none {
      // Only c is present - align right
      return align(c, right)
    } else if a == none and c != none {
      // b and c are present - b in middle, c at right
      // return stack(h(2fr), b, h(1fr), c, dir: ltr)
      return {
          place(b, center)
          place(c, right)
      }
    } else if b == none and c == none {
      // Only a is present - align left
      return align(a, left)
    } else if b == none and a != none and c != none {
      // a and c are present - align at extremes
      return stack(a, h(1fr), c, dir: ltr)
    } else if c == none and a != none and b != none {
      // a and b are present - a at left, b in middle
      return stack(a, h(1fr), b, h(1fr), dir: ltr)
    } 
else if a == none and c != none and b != none {
      // a and b are present - a at left, b in middle
      // plac
      return stack(h(1fr), b, h(1fr), c, dir: ltr)
    } 

    else {
      // All three arguments are present (a, b, c)
      return stack(a, h(1fr), b, h(1fr), c, dir: ltr)
    }
  } else if l == 1 {
    // Handle single argument case - centered by default
    return align(args.at(0), center)
  } else if l == 0 {
    // Handle case with no arguments
    return none
  } else {
    // Handle case with more than 3 arguments
    // Distribute them evenly across the available space
    let items = ()
    for i in range(l) {
      items.push(args.at(i))
      if i < l - 1 {
        items.push(h(1fr))
      }
    }
    return stack(..items, dir: ltr)
  }
}

#let flex-2d(..sink, v-spacing: none, h-spacing: none) = {
    let args = sink.pos()
    let groups = partition(args, (x) => x == parbreak)
    let h-attrs = if h-spacing != none {
        (spacing: h-spacing)
    } else {
        (:)
    }
    let v-attrs = if v-spacing != none{
        (spacing: v-spacing)
    } else {
        (:)
    }
    let rows = groups.map((elements) => {
        return flex(..elements, ..h-attrs)
    })
    return flex(rows, ..v-attrs, dir: ttb)
}

#let arrow-table(items, arrow-length: 10pt) = (
  // similar to answer-reference-table used in one of the worksheets
  context {
    let widthes = items.map(x => measure(x.first()).width)
    let max-width = calc.max(..widthes)
    let columns = (max-width, arrow-length, auto)
    for item in items {
      arrow-flex(..item, columns: columns, column-gutter: 5pt, arrow-length: 10pt)
    }
  }
)

#let vflex = flex.with(dir: ttb, centered: false)
#let hflex = flex.with(dir: ltr, centered: false)
