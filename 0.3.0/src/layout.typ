#import "ao.typ": merge-attrs, filter-none, to-array
#let flex(
  spacing: 5pt, dir: ltr,
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
    (horizon, items.len())
  } else {
    (center, 1)
  }
  grid(
    ..items, columns: columns, gutter: spacing,
    align: align,
  )
}



// creates an inner grid with lines radiating outwards.
// there is no border
#let inner-grid(
  items, columns: 3, stroke: 0.25pt,
) = {
  let rows = int(items.len() / columns)
  set table(
    stroke: (x, y) => (
      left: if x > 0 { stroke }, top: if y > 0 { stroke },
    ),
    columns: (1fr,) * columns,
    inset: 0pt,
    rows: (1fr,) * rows,
  )

  table(..items)
}

