/// Creates a math problemset with numbered questions
/// - start: Starting question number (default: 1)
/// - layout: "list" or "grid" (default: "list")
/// - columns: Number of columns for grid layout (default: 2)
/// - flow: "row" or "column" - direction items flow in grid (default: "row")
/// - spacing: Distance between question items (default: 1.5em)
/// - align: Alignment between qnum and question content (default: horizon)
/// - qnum: Callback that takes question number and returns formatted content
/// - questions: Array of question content
#import "@local/typkit:0.3.0" as tk
#let question-set(
  start: 1,
  layout: "list",
  columns: 2,
  flow: "row",
  spacing: 2.5em,
  align: horizon,
  qnum: n => [*#n.*],
  questions: (),
) = {
  // Build each question item with qnum + content
  let make-item(idx, content) = {
    box(
      stack(
        dir: ltr,
        spacing: 0.8em,
        qnum(start + idx),
        content,
      ),
    )
  }

  if layout == "list" {
    stack(
      dir: ttb,
      spacing: spacing,
      ..questions.enumerate().map(((i, q)) => make-item(i, q)),
    )
  } else if layout == "grid" {
    let items = questions.enumerate().map(((i, q)) => make-item(i, q))
    let count = items.len()
    let rows = calc.ceil(count / columns)

    if flow == "column" {
      // Reorder for column-first flow
      let reordered = ()
      for i in range(count) {
        let row = calc.rem(i, rows)
        let col = calc.floor(i / rows)
        let orig = row * columns + col
        if orig < count {
          reordered.push(items.at(orig))
        }
      }
      items = reordered
    }

    grid(
      columns: (1fr,) * columns,
      column-gutter: 2em,
      row-gutter: spacing,
      ..items
    )
  }
}

// Example usage:

#set page(margin: 1in, height: 6in)
#set text(size: 12pt)


#question-set(
  start: 3,
  layout: "grid",
  spacing: 1fr,
  columns: 2,
  questions: (
    rect(),
    rect(),
    rect(),
    rect(),
    rect(),
    rect(),
  ),
)

