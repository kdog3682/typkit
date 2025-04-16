
#import "base.typ": arrow
#import "ao.typ": merge-attrs, filter-none
#import "layout.typ": flex
#import "base.typ": tern, exists, to-content, mirror
#import "./strokes.typ"
#import "./patterns.typ"
#let strokes = dictionary(strokes)
#let patterns = dictionary(patterns)
// Store original functions
#let _strike = strike
#let _underline = underline
#let _pad = pad
#let _place = place
#let _align = align
#let _rotate = rotate
#let _content = content
#let _circle = circle
#let _rect = rect
#let _scale = scale
#let _flex = flex

#let is-math-content(x) = {
  type(x) == content and x.func() == math.equation
}
// Helper function to filter out none values

// Style lookup dictionaries
#let underline_styles = (
  "default": (
    stroke: black + 0.5pt,
    offset: 2pt,
  ),
  "thick": (
    stroke: black + 1pt,
    offset: 2pt,
  ),
  "thin": (
    stroke: black + 0.3pt,
    offset: 1.5pt,
  ),
  "blue": (
    stroke: blue + 0.5pt,
    offset: 2pt,
  ),
  "red": (
    stroke: red + 0.5pt,
    offset: 2pt,
  ),
  "dotted": (
    stroke: (
      paint: black,
      dash: "dotted",
      thickness: 0.5pt,
    ),
    offset: 2pt,
  ),
  "dashed": (
    stroke: (
      paint: black,
      dash: "dashed",
      thickness: 0.5pt,
    ),
    offset: 2pt,
  ),
)

#let strike_styles = (
  "default": (:),
  "thick": (
    stroke: black + 1pt,
    offset: 0pt,
  ),
  "thin": (
    stroke: black + 0.3pt,
    offset: 0pt,
  ),
  "blue": (
    stroke: blue + 0.5pt,
    offset: 0pt,
  ),
  "red": (stroke: red),
  "dotted": (
    stroke: (
      paint: black,
      dash: "dotted",
      thickness: 0.5pt,
    ),
    offset: 0pt,
  ),
  "dashed": (
    stroke: (
      paint: black,
      dash: "dashed",
      thickness: 0.5pt,
    ),
    offset: 0pt,
  ),
)

// Complete resolver function (from previous example)
#let resolve-unit(key, value) = {
  // First handle color properties
  let ty = type(value)
  if ty == str {
    if key in (
      "fg",
      "bg",
      "fill",
      "stroke",
      "align",
    ) {
      if key == "fill" {
        let stroke = patterns.at(value, default: none)
        if exists(stroke) {
          return stroke
        }
      }
      if key == "stroke" {
        let stroke = strokes.at(value, default: none)
        if exists(stroke) {
          return stroke
        }
      }
      return eval(value, scope: ("strokes": strokes, "patterns": patterns))
    } else if value.ends-with("em") or value.ends-with("pt") or value.ends-with("%") {
      return eval(value)
    } else {
      return value
    }
  } else if ty in (int, float) {
    return {
      if key == "rotate" {
        value * 1deg
      } else if key in (
        "width", "height", "w", "h",
        "x", "y", "top", "left",
        "right", "bottom",
      ) {
        value * 1pt
      } else if key in (
        "font-size", "size", "indent", "margin",
        "padding", "line-spacing",
      ) {
        value * 1em
      } else {
        // Default to points
        value * 1pt
      }
    }
  }

  // Fallback for other cases
  else {
    value
  }
}

#let resolve-class(obj) = {
  let store = (:)
  for (key, value) in obj {
    store.insert(key, resolve-unit(key, value))
  }
  return store
}

#let placer(place: "center", delta: 2pt, dx: none, dy: none, body) = {
  // Define the placement mappings
  if type(place) == alignment {
    return _place(body, place, dx: dx, dy: dy)
  }
  let placements = (
    "nw": (align: top + left, dx: 1, dy: 1),
    "n": (align: top, dx: 0pt, dy: 1),
    "ne": (align: top + right, dx: -1, dy: 1),
    "w": (align: left, dx: 1, dy: 0pt),
    "e": (align: right, dx: -1, dy: 0pt),
    "sw": (align: bottom + left, dx: 1, dy: -1),
    "s": (align: bottom, dx: 0pt, dy: -1),
    "se": (align: bottom + right, dx: -1, dy: -1),
    "center": (align: center, dx: 0pt, dy: 0pt),
  )

  // Get the placement info or default to center
  let info = placements.at(place)
  _place(body, info.align, dx: info.dx * delta, dy: info.dy * delta)
}

#let div(
  ..sink,
  // Box attributes
  width: none, height: none, bg: none,
  wh: none, stroke: none, radius: none,
  colors: none,
  wrapper: box,
  markup: false,
  inset: none, outset: none, clip: none,
  caption: none,
  hidden: false,
  dx: 0pt, dy: 0pt,
  // Text attributes
  font: none, fg: none, size: none,
  fill: none, bold: none, italic: none,
  style: none, weight: none, slant: none,
  tracking: none, class: none, pad-left: none,
  margin-left: none, margin-bottom: none,
  margin-top: none, margin-right: none,
  spacing: none, baseline: none, overhang: false,
  dir: ltr,
  place: none,
  delta: 0pt,
  caption-position: "bottom",
  // Underline attributes
  underline: none,
  // Strike attributes
  strike: none, scale: none,
  // Alignment (happens before box)
  align: none,
  northwest: none,
  southeast: none,
  southwest: none,
  northeast: none,
  north: none,
  south: none,
  east: none,
  west: none,
  // Rotation (happens after box)
  rotate: none, circle: none, centered: false,
) = {

  let args = sink.pos()
  if northwest != none { args.push(div(northwest, place: "nw"))}
  if southeast != none { args.push(div(southeast, place: "se"))}
  if southwest != none { args.push(div(southwest, place: "sw"))}
  if northeast != none { args.push(div(northeast, place: "ne"))}
  if north != none { args.push(div(north, place: "n"))}
  if south != none { args.push(div(south, place: "s"))}
  if east != none { args.push(div(east, place: "e"))}
  if west != none { args.push(div(west, place: "w"))}
  let content = if args.len() == 1 {
    args.first()
  } else if args.len() == 0 {
    none
  } else {
    // panic("arrays are not allowed for div. only 1 or 0 positional args is allowed")
    if flex == true {
      _flex(..args, spacing: spacing, dir: dir)
    } else {
      args.join()
    }
    // panic("div is only allowed to have 1 or 0 positional args.")
  }
  if class != none {
    return div(
      content,
      ..resolve-class(class),
    )
  }
  // Process content with the combined functionalities
  // set par(spacing: 1em)
  let t = type(content)
  if t == int or t == float {
    content = str(content)
  } else if content == false {
    content = text("hi")
    hidden = true
  } else if markup == true and t == str {
    content = eval(content, mode: "markup")
  } else if t == array {
    panic("arrays are not allowed for div")
    content = if flex == true {
      _flex(..content, spacing: spacing, dir: dir)
    } else {
      content.join()
    }
  }
  let result = content
  if centered == true {
    align = center + horizon
  }
  if wh != none {
    width = wh
    height = wh
  }
  if fill != none {
    bg = fill
  }

  if colors != none {
    bg = colors.last()
    fg = colors.first()
  }

  // Apply text formatting
  let text_attrs = (
    font: font,
    fill: fg,
    size: size,
    style: style,
    weight: weight,
    slant: slant,
    tracking: tracking,
    baseline: baseline,
    overhang: overhang,
  )
  if bold != none {
    text_attrs.weight = "bold"
  }
  if italic != none {
    text_attrs.style = "italic"
  }

  let filtered_text_attrs = filter-none(text_attrs)
  if result != none {
    if filtered_text_attrs.len() > 0 {
      result = text(
        result,
        ..filtered_text_attrs,
      )
    } else if type(result) != _content {
      result = text(result)
    }
    if bold != none and is-math-content(content) {
      result = math.equation(math.bold(result))
    }

    if strike != none {
      let strike_attrs = (:)

      let strike_attrs = if strike == true {
        strike_styles.default
      } else if type(strike) == str {
        if strike in strike_styles {
          strike_styles.at(strike)
        } else {
          strike_styles.default
        }
      } else if type(strike) == dictionary {
        strike
      }

      result = _strike(result, ..strike_attrs)
    }

    // Apply underline if specified
    if underline != none and underline != false {
      let underline_attrs = (:)

      if underline == true {
        // Use default underline style
        underline_attrs = underline_styles.default
      } else if type(underline) == str {
        // Lookup style by name
        underline_attrs = if underline in underline_styles {
          underline_styles.at(underline)
        } else {
          underline_styles.default
        }
      } else if type(underline) == dictionary {
        // Use custom underline attributes
        underline_attrs = underline
      }

      result = _underline(result, ..underline_attrs)
    }

    // Apply alignment before box
    if align != none {
      result = _align(result, align)
    }
  }

  let circle_attrs = (
    fill: bg,
    stroke: stroke,
    radius: radius,
  )

  // Apply box
  if type(stroke) == str {
    stroke = strokes.at(stroke)
  }
  let box_attrs = (
    width: width,
    height: height,
    fill: bg,
    stroke: stroke,
    radius: radius,
    inset: inset,
    outset: outset,
    clip: clip,
  )

  let filtered_circle_attrs = filter-none(circle_attrs)
  if circle == true and filtered_circle_attrs.len() > 0 {
    // panic(filtered_circle_attrs, circle_attrs)
    result = _circle(
      result,
      ..filtered_circle_attrs,
    )
  } else if wrapper == box {
    let filtered_box_attrs = filter-none(box_attrs)
    if filtered_box_attrs.len() > 0 {
      result = box(
        result,
        ..filtered_box_attrs,
      )
    }
  } else if wrapper == block {

    let filtered_box_attrs = filter-none(box_attrs)
    if filtered_box_attrs.len() > 0 {
      // 2025-04-15 aicmp: turn this to block
      result = block(
        result,
        ..filtered_box_attrs,
      )
    }
  }

  // Apply rotation after box
  if rotate != none {
    result = _rotate(result, rotate)
  }
  if pad-left != none {
    result = _pad(result, left: pad-left)
  }
  if margin-bottom != none {
    result = _pad(
      result,
      bottom: margin-bottom,
    )
  }
  if margin-top != none {
    result = _pad(
      result,
      bottom: margin-top,
    )
  }
  if margin-left != none {
    result = _pad(
      result,
      bottom: margin-left,
    )
  }
  if margin-right != none {
    result = _pad(
      result,
      bottom: margin-right,
    )
  }
  if place != none {
    result = placer(place: place, delta: delta, dx: dx, dy: dy, result)
  }
  if scale != none {
    result = _scale(
      result,
      scale,
      reflow: true,
    )
  }
  if hidden == true {
    return hide(result)
  }

  if caption != none {
    if caption-position == "above" {
        flex(caption, result, dir: ttb, spacing: 10pt)
    } else {
        flex(result, caption, dir: ttb, spacing: 10pt)
    }
  } else {
    result
  }
}

#let myStyles = (
  rotate: 90,
  width: 200,
  fill: "red.lighten(20%)",
  bg: "rgb(128, 128, 128)",
)

#let clsx(a, ..sink) = {
  let args = sink.pos()
  let b = if args.len() == 1 {
    args.at(0)
  } else {
    none
  }
  let attrs = resolve-class(merge-attrs(b, sink.named()))
  return div(a, ..attrs)
}

// #panic(clsx("hi     l,", myStyles, rotate: 120deg, stroke: "gentle", fill: "circles"))



#let nd(numerator, denominator, ..sink) = {
  let builder(x) = {
    if type(x) == int {
      str(x)
    } else if x == "[]" {
      move(div(stroke: 1pt, wh: 10pt), dy: 5pt)
    }
  }
  let n = builder(numerator)
  let d = builder(denominator)
  let expr = $#n/#move(d, dy: 0.5pt)$
  return div(expr, ..sink)
}

#let shape(body, items: none, left: none, right: none, top: none, bottom: none, spacing: 10pt, arrow-length: 10pt, arrow-spacing: 15pt) = {
  if items != none {
       top = items.at(0, default: none)
       right = items.at(1, default: none)
       bottom = items.at(2, default: none)
       left = items.at(3, default: none)
  }
  let horo = ()
  if left != none and right != none {
    horo.push(left)
    horo.push(arrow(arrow-length, angle: 180deg))
    horo.push(body)
    horo.push(arrow(arrow-length, angle: 0deg))
    horo.push(right)
  } else if right != none {
    horo.push(body)
    horo.push(arrow(arrow-length, angle: 0deg))
    horo.push(right)
  } else if left != none {
    horo.push(left)
    horo.push(arrow(arrow-length, angle: 180deg))
    horo.push(body)
  } else {
    horo.push(body)
  }

  let horo = flex(horo, dir: ltr, spacing: arrow-spacing)
  let vertical = ()

  if top != none and bottom != none {
    vertical.push(top)
    vertical.push(arrow(arrow-length, angle: 90deg, dy: -6pt))
    vertical.push(horo)
    vertical.push(arrow(arrow-length, angle: 270deg))
    vertical.push(bottom)
  } else if bottom != none {
    vertical.push(horo)
    vertical.push(arrow(arrow-length, angle: 270deg))
    vertical.push(bottom)
  } else if top != none {
    vertical.push(top)
    vertical.push(v(15pt))
    vertical.push(arrow(arrow-length, angle: 90deg))
    vertical.push(horo)
  } else {
    vertical.push(horo)
  }

  flex(vertical, dir: ttb, spacing: arrow-spacing)
}
