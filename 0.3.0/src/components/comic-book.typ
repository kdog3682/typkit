/// still could use a bit of work

#set page(
  paper: "us-letter",
  margin: 0.5in,
  fill: white,
)

// Parse template into grid and panel definitions
#let parse-template(template) = {
  let lines = template.split("\n").map(l => l.trim()).filter(l => l.len() > 0)
  let rows = lines.len()
  let cols = calc.max(..lines.map(l => l.clusters().len()))
  
  // Build grid with normalized columns
  let grid = lines.map(l => {
    let chars = l.clusters()
    while chars.len() < cols { chars.push(" ") }
    chars
  })
  
  // Find panels and their spans
  let panels = (:)
  for (row-idx, row) in grid.enumerate() {
    for (col-idx, char) in row.enumerate() {
      if char != " " {
        if char in panels {
          let p = panels.at(char)
          panels.at(char) = (
            id: char,
            row-start: calc.min(p.row-start, row-idx),
            row-end: calc.max(p.row-end, row-idx),
            col-start: calc.min(p.col-start, col-idx),
            col-end: calc.max(p.col-end, col-idx),
          )
        } else {
          panels.insert(char, (
            id: char,
            row-start: row-idx,
            row-end: row-idx,
            col-start: col-idx,
            col-end: col-idx,
          ))
        }
      }
    }
  }
  
  (grid: grid, panels: panels, rows: rows, cols: cols)
}

// Main comic layout function using table
#let comic-layout(
  template,
  panels,
  width: 100%,
  height: auto,
  gutter: 3pt,
  inset: 10pt,
  line-width: 2pt,
  line-color: black,
  show-lines: true,
) = {
  let parsed = parse-template(template)
  let grid = parsed.grid
  let row-count = parsed.rows
  let col-count = parsed.cols
  let panel-defs = parsed.panels
  
  let line-stroke = line-width + line-color
  
  // Track which cells have been rendered (for rowspan/colspan)
  let rendered = grid.map(row => row.map(_ => false))
  
  // Build table cells
  let cells = ()
  
  for row in range(row-count) {
    for col in range(col-count) {
      let char = grid.at(row).at(col)
      
      // Skip if already rendered as part of a span
      if rendered.at(row).at(col) { continue }
      
      if char == " " {
        // Empty cell
        cells.push(table.cell(
          stroke: none,
          inset: gutter / 2,
          []
        ))
      } else {
        let p = panel-defs.at(char)
        let rowspan = p.row-end - p.row-start + 1
        let colspan = p.col-end - p.col-start + 1
        
        // Mark cells as rendered
        for r in range(p.row-start, p.row-end + 1) {
          for c in range(p.col-start, p.col-end + 1) {
            rendered.at(r).at(c) = true
          }
        }
        
        // Calculate stroke for this panel's edges
        let panel-stroke = if show-lines {
          // Check each edge of the panel
          let top = if p.row-start > 0 {
            // Check all cells above the panel
            let needs-line = false
            for c in range(p.col-start, p.col-end + 1) {
              let above = grid.at(p.row-start - 1).at(c)
              if above != " " and above != char { needs-line = true }
            }
            if needs-line { line-stroke } else { none }
          } else { none }
          
          let bottom = if p.row-end < row-count - 1 {
            let needs-line = false
            for c in range(p.col-start, p.col-end + 1) {
              let below = grid.at(p.row-end + 1).at(c)
              if below != " " and below != char { needs-line = true }
            }
            if needs-line { line-stroke } else { none }
          } else { none }
          
          let left = if p.col-start > 0 {
            let needs-line = false
            for r in range(p.row-start, p.row-end + 1) {
              let left-cell = grid.at(r).at(p.col-start - 1)
              if left-cell != " " and left-cell != char { needs-line = true }
            }
            if needs-line { line-stroke } else { none }
          } else { none }
          
          let right = if p.col-end < col-count - 1 {
            let needs-line = false
            for r in range(p.row-start, p.row-end + 1) {
              let right-cell = grid.at(r).at(p.col-end + 1)
              if right-cell != " " and right-cell != char { needs-line = true }
            }
            if needs-line { line-stroke } else { none }
          } else { none }
          
          (top: top, bottom: bottom, left: left, right: right)
        } else {
          none
        }
        
        let content = if char in panels { panels.at(char) } else { none }
        
        cells.push(table.cell(
          rowspan: rowspan,
          colspan: colspan,
          stroke: panel-stroke,
          fill: white,
          inset: inset,
          content
        ))
      }
    }
  }
  
  // Calculate row heights
  let row-heights = if height == auto {
    (1fr,) * row-count
  } else {
    (height / row-count,) * row-count
  }
  
  table(
    columns: (1fr,) * col-count,
    rows: row-heights,
    gutter: gutter,
    ..cells
  )
}

// ============================================================
// EXAMPLES
// ============================================================

#block(comic-layout(
  "aabbcc
   aabbcc
   ddddee
   ffghee
   ffghee",
  (
    a: align(center + horizon)[A],
    b: align(center + horizon)[B],
    c: align(center + horizon)[C],
    d: align(center + horizon)[D],
    e: align(center + horizon)[E],
    f: align(center + horizon)[F],
    g: align(center + horizon)[G],
    h: align(center + horizon)[H],
  ),
  height: 4in,
  line-width: 2pt,
  line-color: black,
  show-lines: false
), fill: black, stroke: black + 5pt)


