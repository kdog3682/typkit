#let DEFAULT-DIVIDER = (stroke: (dash: "dotted", thickness: 0.45pt))
#let DEFAULT-FULL-WIDTH = (inset: (x: 0pt, y: 10pt), align: left)

/// Renders structured dialogue with speakers, content, and optional assets.
///
/// Supports three item types:
/// - `single`: A single dialogue line with speaker, content, and optional asset
/// - `group`: Multiple dialogue lines sharing a single asset (asset spans all rows)
/// - `full-width-content`: Content spanning all columns (e.g., scene breaks, stage directions)
///
/// - items (array): Array of dialogue items. Each item is a dictionary with:
///   - `kind` (str): `"single"` (default), `"group"`, or `"full-width-content"`
///   - For `single`: `speaker` (content), `content` (content), `asset` (content, optional)
///   - For `group`: `entries` (array of `(speaker, content)` dicts), `asset` (content, optional)
///   - For `full-width-content`: `content` (content), `inset` (optional), `align` (optional)
/// - speaker-width (auto, length): Width of speaker column
/// - content-width (length): Width of content column
/// - asset-width (auto, length): Width of asset column
/// - speaker-content-gap (length): Gap between speaker and content columns
/// - content-asset-gap (length): Gap between content and asset columns
/// - row-gap (length): Vertical gap between rows. Halved when `row-divider` is enabled,
///   except within groups which maintain full spacing.
/// - inset (length, dictionary): Cell inset for the grid
/// - stroke (stroke, none): Grid stroke
/// - row-divider (none, bool, dictionary): Divider between rows.
///   - `none` or `false`: No dividers
///   - `true`: Uses `DEFAULT-DIVIDER`
///   - `dictionary`: Custom divider with `stroke`, `above` (length), `below` (length)
/// - speaker-align (alignment): Alignment for speaker cells
/// - content-align (alignment): Alignment for content cells
/// - asset-align (alignment): Alignment for asset cells
/// - speaker-style (function): Styling function applied to speaker content
/// - full-width-content (dictionary): Default options for full-width items (`inset`, `align`)
/// -> content
#let dialogue(
  items,
  speaker-width: auto,
  content-width: 200pt,
  asset-width: auto,
  speaker-content-gap: 10pt,
  content-asset-gap: 16pt,
  row-gap: 18pt,
  inset: 0pt,
  stroke: white,
  row-divider: none,
  speaker-align: auto,
  content-align: auto,
  asset-align: horizon,
  speaker-style: text.with(weight: "bold"),
  full-width-content: DEFAULT-FULL-WIDTH,
) = {
  if row-divider != none and row-divider != false {
    if type(row-divider) != dictionary {
      row-divider = DEFAULT-DIVIDER
    }
  } else {
    row-divider = none
  }

  let base-gap = if row-divider != none { row-gap / 2 } else { row-gap }
  // Extra inset needed within groups to restore full row-gap
  let group-inner-inset = if row-divider != none { row-gap / 4 } else { 0pt }

  // Creates divider cell(s) if enabled and not first row
  let make-divider(row-index) = {
    if row-divider != none and row-index > 0 {
      let div = row-divider
      (
        grid.cell(
          colspan: 3,
          inset: (top: div.at("above", default: 4pt), bottom: div.at("below", default: 4pt)),
          line(length: 100%, stroke: div.stroke),
        ),
      )
    } else {
      ()
    }
  }

  // Creates cells for a standard row (speaker, content, optionally asset)
  let make-row(
    speaker,
    content,
    asset: none,
    asset-rowspan: 1,
    include-asset: true,
    top-inset: 0pt,
    bottom-inset: 0pt,
  ) = {
    let cell-inset = (top: top-inset, bottom: bottom-inset)
    let cells = (
      grid.cell(align: speaker-align, inset: cell-inset, (speaker-style)(speaker)),
      grid.cell(align: content-align, inset: cell-inset, content),
    )
    if include-asset {
      cells.push(
        grid.cell(
          rowspan: asset-rowspan,
          align: asset-align,
          if asset != none { asset } else { [] },
        ),
      )
    }
    cells
  }

  let cells = ()
  let row-index = 0

  for item in items {
    let kind = item.at("kind", default: "single")

    if kind == "full-width-content" {
      cells += make-divider(row-index)
      let defaults = full-width-content
      cells.push(
        grid.cell(
          colspan: 3,
          inset: item.at("inset", default: defaults.at("inset", default: (x: 20pt, y: 10pt))),
          align: item.at("align", default: defaults.at("align", default: left)),
          item.content,
        ),
      )
      row-index += 1
    } else if kind == "group" {
      let entries = item.entries
      let asset = item.at("asset", default: none)
      let count = entries.len()

      for (i, entry) in entries.enumerate() {
        if i == 0 {
          cells += make-divider(row-index)
        }
        // Calculate inset for group rows to maintain full spacing internally
        let top = if i > 0 { group-inner-inset } else { 0pt }
        let bottom = if i < count - 1 { group-inner-inset } else { 0pt }

        cells += make-row(
          entry.speaker,
          entry.content,
          asset: if i == 0 { asset } else { none },
          asset-rowspan: count,
          include-asset: i == 0,
          top-inset: top,
          bottom-inset: bottom,
        )
        row-index += 1
      }
    } else {
      // kind == "single"
      cells += make-divider(row-index)
      cells += make-row(item.speaker, item.content, asset: item.at("asset", default: none))
      row-index += 1
    }
  }

  grid(
    columns: (speaker-width, content-width, asset-width),
    column-gutter: (speaker-content-gap, content-asset-gap),
    row-gutter: base-gap,
    stroke: stroke,
    inset: inset,
    ..cells
  )
}
