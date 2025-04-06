#import "base.typ": arrow
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
