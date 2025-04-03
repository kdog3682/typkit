
#import "ao.typ": merge-attrs
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

#let is-math-content(x) = {
  type(x) == content and x.func() == math.equation
}
// Helper function to filter out none values
#let filter-none(dict) = {
  let result = (:)
  for (key, value) in dict.pairs() {
    if value != none {
      result.insert(key, value)
    }
  }
  return result
}

// Style lookup dictionaries
#let underline_styles = (
  "default": (
    stroke: black + 0.5pt, offset: 2pt,
  ), "thick": (
    stroke: black + 1pt, offset: 2pt,
  ), "thin": (
    stroke: black + 0.3pt, offset: 1.5pt,
  ), "blue": (
    stroke: blue + 0.5pt, offset: 2pt,
  ),
  "red": (
    stroke: red + 0.5pt, offset: 2pt,
  ), "dotted": (
    stroke: (
      paint: black, dash: "dotted", thickness: 0.5pt,
    ), offset: 2pt,
  ), "dashed": (
    stroke: (
      paint: black, dash: "dashed", thickness: 0.5pt,
    ), offset: 2pt,
  ),
)

#let strike_styles = (
  "default": (:), "thick": (
    stroke: black + 1pt, offset: 0pt,
  ), "thin": (
    stroke: black + 0.3pt, offset: 0pt,
  ), "blue": (
    stroke: blue + 0.5pt, offset: 0pt,
  ),
  "red": (stroke: red), "dotted": (
    stroke: (
      paint: black, dash: "dotted", thickness: 0.5pt,
    ), offset: 0pt,
  ), "dashed": (
    stroke: (
      paint: black, dash: "dashed", thickness: 0.5pt,
    ), offset: 0pt,
  ),
)

// Complete resolver function (from previous example)
#let resolve-unit(key, value) = {
  // First handle color properties
  let ty = type(value)
  if ty == str {
    if key in (
      "fg", "bg", "fill", "stroke", "align", 
    ) {
      if key == "fill" {
        let stroke = patterns.at(value, default: none)
        if exists(stroke){
            return stroke
        }
      }
      if key == "stroke" {
        let stroke = strokes.at(value, default: none)
        if exists(stroke){
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

#let placer(place: "center", delta: 2pt, body) = {
  // Define the placement mappings
  let placements = (
    "nw": (align: top + left,    dx:  delta, dy:  delta),
    "n":  (align: top,            dx:  0pt,   dy:  delta),
    "ne": (align: top + right,    dx: -delta, dy:  delta),
    "w":  (align: left,           dx:  delta, dy:  0pt),
    "e":  (align: right,          dx: -delta, dy:  0pt),
    "sw": (align: bottom + left,  dx:  delta, dy: -delta),
    "s":  (align: bottom,         dx:  0pt,   dy: -delta),
    "se": (align: bottom + right, dx: -delta, dy: -delta),
    "center": (align: center,     dx:  0pt,   dy:  0pt),
  )

  // Get the placement info or default to center
  let info = placements.at(place)
  _place(body, info.align, dx: info.dx, dy: info.dy)
}

#let div(
  ..sink,
  // Box attributes
  width: none, height: none, bg: none,
  wh: none, stroke: none, radius: none,
  markup: false,
  inset: none, outset: none, clip: none,
  hidden: false,
  // Text attributes
  font: none, fg: none, size: none,
  fill: none, bold: none, italic: none,
  style: none, weight: none, slant: none,
  tracking: none, class: none, pad-left: none,
  margin-left: none, margin-bottom: none,
  margin-top: none, margin-right: none,
  spacing: none, baseline: none, overhang: false,
  place: none,
  delta: 0pt,
  // Underline attributes
  underline: none,
  // Strike attributes
  strike: none, scale: none,
  // Alignment (happens before box)
  align: none,
  // Rotation (happens after box)
  rotate: none, circle: none, centered: false,
) = {

  let args = sink.pos()
  let content = if args.len() == 1 {args.first()} else if args.len() == 0{none} else {
    flex(..args, spacing: spacing)
      // panic("div is only allowed to have 1 or 0 positional args.")
  }
  if class != none {
    return div(
      content, ..resolve-class(class),
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
    content = eval(content, mode:  "markup")
  }
  // else if type(content) == array {
  //   content = content.join()
  // }
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

  // Apply text formatting
  let text_attrs = (
    font: font, fill: fg, size: size,
    style: style, weight: weight, slant: slant,
    tracking: tracking, 
    baseline: baseline, overhang: overhang,
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
        result, ..filtered_text_attrs,
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
    fill: bg, stroke: stroke, radius: radius,
  )

  // Apply box
  if type(stroke) == str {
    stroke = strokes.at(stroke)
  }
  let box_attrs = (
    width: width, height: height, fill: bg,
    stroke: stroke, radius: radius, inset: inset,
    outset: outset, clip: clip,
  )

  let filtered_circle_attrs = filter-none(circle_attrs)
  if circle == true and filtered_circle_attrs.len() > 0 {
    // panic(filtered_circle_attrs, circle_attrs)
    result = _circle(
      result, ..filtered_circle_attrs,
    )
  } else {
    let filtered_box_attrs = filter-none(box_attrs)
    if filtered_box_attrs.len() > 0 {
      result = box(
        result, ..filtered_box_attrs,
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
      result, bottom: margin-bottom,
    )
  }
  if margin-top != none {
    result = _pad(
      result, bottom: margin-top,
    )
  }
  if margin-left != none {
    result = _pad(
      result, bottom: margin-left,
    )
  }
  if margin-right != none {
    result = _pad(
      result, bottom: margin-right,
    )
  }
  if place != none {
    result = placer(place: place, delta: delta, result)
  }
  if scale != none {
    result = _scale(
      result, scale, reflow: true,
    )
  }
  if hidden == true {
    return hide(result)
  }

  return result
}

#let myStyles = (
  rotate: 90, width: 200, fill: "red.lighten(20%)",
  bg: "rgb(128, 128, 128)",
)

// #panic(div(12, class: myStyles))

#let clsx(a, ..sink) = {
    let args = sink.pos()
    let b = if args.len() == 1 {args.at(0)} else {none}
    let attrs = resolve-class(merge-attrs(b, sink.named()))
    return div(a, ..attrs)
}

// #panic(clsx("hi     l,", myStyles, rotate: 120deg, stroke: "gentle", fill: "circles"))
