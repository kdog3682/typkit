#import "base.typ": arrow
#import "layout.typ": *
#import "div.typ": div
#import "ao.typ": merge-attrs

/// the items are interspersed with arrows
/// the number of columns is the number of total items
/// no base attributes are set
/// however ...
/// 
/// if "columns" not in named {
///    base.insert("column-gutter", spacing)
/// }
/// is pretty important. it ensures that there is always some spacing.
/// 
/// let attrs = (
///    align: left + horizon, columns: (20pt, 20pt, 10pt),
///  )
///
/// the above attributes are used to create the arrows in answer-reference-table
/// when adjust is present, it becomes contextual
/// uses move() to place the items properly
///
// it doesnt work
// let args = sink.pos()
// let a = grid.cell(arrow(arrow-length), align: horizon)
// let items = args.intersperse(a)
// return grid(..items, columns: items.len(), column-gutter: spacing)
// it is actually possible to make the entire thing implicit. 
// 
#let arrow-flex(..sink, spacing: 10pt, arrow-length: 10pt, adjust: none) = (
  context {
    let arrow-extra-dy = 1pt
    if adjust != none {
      let args = sink.pos()
      let first = args.first()
      let height = measure(first).height
      let arrow-dy = height / 2
      let arrow-element = arrow(arrow-length, dy: arrow-dy + arrow-extra-dy)
      let adjustment((i, it)) = {
        if i == 0 {
          return it
        }
        let h = measure(it).height
        if h > height {
          return move(it, dy: -arrow-dy)
        } else {
          return it
        }
      }
      let items = args.enumerate().map(adjustment).intersperse(arrow-element)
      return stack(..items, dir: ltr, spacing: spacing)
    } else {

      let items = sink.pos().intersperse(arrow(arrow-length, dy: arrow-extra-dy / 2))
      let named = sink.named()
      let base = (align: left + horizon, columns: items.len())
      if "columns" not in named {
        base.insert("column-gutter", spacing)
      }
      return grid(
        ..items,
        ..merge-attrs(base, named)
      )
    }
  }
)

/// this is a debugging component
/// makes a rectangle of a certain color
#let puck(w, h, color) = {
  rect(width: w * 1pt, height: h * 1pt, fill: color, stroke: none)
}
// #arrow-flex(puck(50, 10, blue), puck(50, 10, green), adjust: true)
// #arrow-flex(puck(50, 20, blue), puck(50, 100, green),  puck(50, 100, green), adjust: true)


/// this is a debugging component
/// writes "n" lines a certain color
#let lines(n, fill: blue) = {
  for i in range(n) {
    text(lorem(3), fill: fill)
    parbreak()
  }
}

/// numbers items
#let numbered(questions, template: "1.", bold: true, start: 1) = {
  let gap = if questions.len() < 15 {
    15pt // you only need a larger gap when there are many items
  } else {
    20pt
  }

  let callback((n, question)) = {
    let s = template.replace("1", str(n))
    let qnum = strong(s)
    grid(
      columns: (gap, auto),
      qnum, question,
    )
  }

  let items = questions.enumerate(start: start).map(callback)
  return items
}

#let blocks(arr, columns: none, gutter: 2pt, ..sink) = {
  let base = (
    wh: 15pt,
    radius: 2pt,
  )
  let attrs = merge-attrs(base, sink.named())
  let callback(fill) = {
    return div(..attrs, fill: fill)
  }
  let blocks = arr.map(callback)
  if columns == none {
    flex(blocks)
  } else {
    grid(..blocks, columns: columns, gutter: gutter)
  }
}




#let qr-code(id) = {
  return div(wh: 25pt, bg: blue)
}




#let bullet-grid(columns: 2, gutter: 10pt, ..sink) = {
  let total_cells = columns * 2
  
  let padded_items = sink.pos()
  while padded_items.len() < total_cells {
    padded_items.push([])  // Add empty content for unfilled cells
  }
  padded_items = padded_items.slice(0, total_cells)
  
  // Create the grid
  let circ = circle(radius: 1pt, fill: black)
  grid(
    columns: columns,
    rows: 2,
    gutter: gutter,
    ..sink.named(),
    ..padded_items.map(item => {
      if item != [] {
        flex(circ, item, spacing: 4pt)
      } else {
        []  // Empty cell
      }
    })
  )
}

#let colon-table(..entries) = {
  let pairs = entries.pos()

  table(
    columns: (auto, 7pt, auto),
    stroke: none,
    inset: 0pt,
    align: left,
    column-gutter: 0pt,
    row-gutter: 5pt,
    ..pairs
      .map(pair => {
          let (a, b) = pair
          (strong(a), [#h(2pt):], b)
        })
      .flatten()
  )
}

#let listicle(items, callback, start: 1, spacing: 10pt, template: "%s") = {
  let runner((n, item)) = {
    let a = div(n, template: template, wh: 22, fg: white, bg: blue, centered: true, bold: true, radius: 3pt)
    let b = move(callback(item), dy: 7pt)
    return grid(a, b, columns: 2, column-gutter: 10pt)
  }
  return items.enumerate(start: start).map(runner).join(v(spacing))
}
