#import "base.typ": arrow, read-data
#import "ao.typ": merge-attrs, filter-none
#import "layout.typ": flex
#import "string.typ": strfmt
#import "base.typ": tern, exists, to-content, mirror
#import "resolve.typ": resolve-point
#import "./strokes.typ"
#import "./patterns.typ"
#let strokes = dictionary(strokes)
#let patterns = dictionary(patterns)

// Preserve originals
#let _strike = strike
#let _underline = underline
#let _pad = pad
#let _place = place
#let _align = align
#let _rotate = rotate
#let _content = content
#let _circle = circle
#let _rect = rect
#let _line = line
#let _scale = scale
#let _flex = flex

#let is-math-content(x) = {
  type(x) == content and x.func() == math.equation
}

// Style dictionaries (unchanged)
#let underline_styles = (
  "default": (stroke: black + 0.5pt, offset: 2pt),
  "thick": (stroke: black + 1pt, offset: 2pt),
  "thin": (stroke: black + 0.3pt, offset: 1.5pt),
  "blue": (stroke: blue + 0.5pt, offset: 2pt),
  "red": (stroke: red + 0.5pt, offset: 2pt),
  "dotted": (stroke: (paint: black, dash: "dotted", thickness: 0.5pt), offset: 2pt),
  "dashed": (stroke: (paint: black, dash: "dashed", thickness: 0.5pt), offset: 2pt),
)

#let strike_styles = (
  "default": (:),
  "thick": (stroke: black + 1pt, offset: 0pt),
  "thin": (stroke: black + 0.3pt, offset: 0pt),
  "blue": (stroke: blue + 0.5pt, offset: 0pt),
  "red": (stroke: red),
  "dotted": (stroke: (paint: black, dash: "dotted", thickness: 0.5pt), offset: 0pt),
  "dashed": (stroke: (paint: black, dash: "dashed", thickness: 0.5pt), offset: 0pt),
)

// === Utilities ===
#let resolve-unit(key, value) = {
  let ty = type(value)
  if ty == str {
    if key in ("fg", "bg", "fill", "stroke", "align") {
      if key == "fill" {
        let pat = patterns.at(value, default: none)
        if exists(pat) {
          return pat
        }
      }
      if key == "stroke" {
        let st = strokes.at(value, default: none)
        if exists(st) {
          return st
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
      } else if key in ("width", "height", "w", "h", "x", "y", "top", "left", "right", "bottom") {
        value * 1pt
      } else if key in ("font-size", "size", "indent", "margin", "padding", "line-spacing") {
        value * 1em
      } else {
        value * 1pt
      }
    }
  } else {
    value
  }
}

#let resolve-class(obj) = {
  let out = (:)
  for (k, v) in obj {
    out.insert(k, resolve-unit(k, v))
  }
  out
}

#let placer(place: "center", delta: 2pt, dx: none, dy: none, body) = {
  if type(place) == alignment {
    return _place(body, place, dx: dx, dy: dy)
  }
  let map = (
    "nw": (align: top + left, dx: 1, dy: 1),
    "n": (align: top, dx: 0, dy: 1),
    "ne": (align: top + right, dx: -1, dy: 1),
    "w": (align: left, dx: 1, dy: 0),
    "e": (align: right, dx: -1, dy: 0),
    "sw": (align: bottom + left, dx: 1, dy: -1),
    "s": (align: bottom, dx: 0, dy: -1),
    "se": (align: bottom + right, dx: -1, dy: -1),
    "center": (align: center, dx: 0, dy: 0),
  )
  let info = map.at(place)
  _place(body, info.align, dx: info.dx * delta, dy: info.dy * delta)
}

#let contentify(x, template: none) = {
  if type(x) == content {
    x
  } else if template != none {
    text(strfmt(template, x))
  } else {
    text(str(x))
  }
}

// === New small helpers for div ===

#let _coerce-content(raw, flex: false, spacing: none, dir: ltr, markup: false, template: none) = {
  if raw == none {
    return none
  }
  let t = type(raw)
  let c = raw
  if t == int or t == float {
    c = str(c)
  } else if c == false {
    return hide(text("hi"))
  } else if markup == true and t == str {
    c = eval(c, mode: "markup")
  } else if t == array {
    c = if flex == true {
      _flex(..raw, spacing: spacing, dir: dir)
    } else {
      raw.join()
    }
  }
  if template != none {
    c = contentify(c, template: template)
  }
  c
}

#let _apply-text(
  result,
  font: none,
  fg: none,
  size: none,
  style: none,
  weight: none,
  slant: none,
  tracking: none,
  text-stroke: none,
  baseline: none,
  overhang: false,
  bold: none,
  italic: none,
  src-content: none,
) = {
  if result == none {
    return none
  }
  if bold  == true {
   weight = "bold"
  }
  let attrs = filter-none((
    font: font,
    fill: fg,
    size: resolve-point(size),
    style: style,
    weight: weight,
    slant: slant,
    tracking: tracking,
    stroke: text-stroke,
    baseline: baseline,
    overhang: overhang,
  ))
  let out = if attrs.len() > 0 {
    text(result, ..attrs)
  } else if type(result) != _content {
    text(result)
  } else {
    result
  }
  if bold != none and is-math-content(src-content) {
    out = math.equation(math.bold(out))
  }
  if italic == true and not is-math-content(src-content) {
    out = emph(out)
  }
  out
}

#let _apply-decorations(node, strike: none, underline: none) = {
  let out = node
  if strike != none {
    let sattrs = if strike == true {
      strike_styles.default
    } else if type(strike) == str {
      strike_styles.at(strike, default: strike_styles.default)
    } else if type(strike) == dictionary {
      strike
    } else {
      (:)
    }
    out = _strike(out, ..sattrs)
  }
  if underline != none and underline != false {
    let uattrs = if underline == true {
      underline_styles.default
    } else if type(underline) == str {
      underline_styles.at(underline, default: underline_styles.default)
    } else if type(underline) == dictionary {
      underline
    } else {
      (:)
    }
    out = _underline(out, ..uattrs)
  }
  out
}

#let _pre-align(node, align: none, centered: false) = {
  let a = if centered == true {
    center + horizon
  } else {
    align
  }
  if a != none {
    _align(node, a)
  } else {
    node
  }
}

#let _wrap-shape(
  node,
  circle: false,
  bg: none,
  stroke: none,
  radius: none,
  inset: none,
  outset: none,
  clip: none,
  paint: none,
  thickness: none,
  dash: none,
  width: none,
  height: none,
  wrapper: box,
) = {
  let s = if type(stroke) == str {
    strokes.at(stroke)
  } else {
    stroke
  }
  if s == none {
    let temp = (:)
    if paint != none { temp.paint = paint}
    if dash != none { temp.dash = dash}
    if thickness != none { temp.thickness = thickness}
    if temp.len() > 0 {
     s = temp
    }
  }
  if circle == true {
    let cattrs = filter-none((fill: bg, stroke: s, radius: radius))
    return if cattrs.len() > 0 {
      _circle(node, ..cattrs)
    } else {
      node
    }
  }
  let battrs = filter-none((
    width: width,
    height: height,
    fill: bg,
    stroke: s,
    radius: radius,
    inset: inset,
    outset: outset,
    clip: clip,
  ))
  if battrs.len() == 0 {
    return node
  }
  if wrapper == block {
    return block(node, ..battrs)
  }
  // default box
  box(node, ..battrs)
}

#let _apply-rotation(node, rotate: none) = {
  if rotate != none {
    _rotate(node, rotate)
  } else {
    node
  }
}

#let _apply-margins(
  node,
  pad-left: none,
  margin-left: none,
  margin-right: none,
  margin-top: none,
  margin-bottom: none,
) = {
  let out = node
  if pad-left != none {
    out = _pad(out, left: pad-left)
  }
  if margin-top != none {
    out = _pad(out, top: margin-top)
  }
  if margin-bottom != none {
    out = _pad(out, bottom: margin-bottom)
  }
  if margin-left != none {
    out = _pad(out, left: margin-left)
  }
  if margin-right != none {
    out = _pad(out, right: margin-right)
  }
  out
}

#let _apply-placement(node, place: none, delta: 0pt, dx: none, dy: none) = {
  if place != none {
    placer(place: place, delta: delta, dx: dx, dy: dy, node)
  } else {
    node
  }
}

#let _apply-scale(node, scale: none) = {
  if scale != none {
    _scale(node, scale, reflow: true)
  } else {
    node
  }
}

#let _apply-caption(node, caption: none, pos: "bottom") = {
  if caption == none {
    return node
  }
  if pos == "above" {
    flex(caption, node, dir: ttb, spacing: 10pt)
  } else {
    flex(node, caption, dir: ttb, spacing: 10pt)
  }
}

#let _apply-rule-and-newline(node, size: none, line: none, line-above: 10, line-below: 20, newline: none) = {
  if line == none {
    return node
  }
  node

  if exists(line) {
    if line == true {
      v(-1pt * line-above)
      _line(length: 100%)
      v(1pt * line-below)
    } else {
      v(-1pt * line-above)
      _line(length: 100%, ..line)
      v(1pt * line-below)
    }
  }
  if exists(newline) {
    if newline == true {
      v(-1 * resolve-point(size) + 5pt)
    } else {
      v(resolve-point(newline))
    }
  }
}

#let _overlay-anchors(
  args,
  north: none,
  south: none,
  east: none,
  west: none,
  ne: none,
  nw: none,
  se: none,
  sw: none,
) = {
  let out = args
  if nw != none {
    out.push(div(nw, place: "nw"))
  }
  if se != none {
    out.push(div(se, place: "se"))
  }
  if sw != none {
    out.push(div(sw, place: "sw"))
  }
  if ne != none {
    out.push(div(ne, place: "ne"))
  }
  if north != none {
    out.push(div(north, place: "n"))
  }
  if south != none {
    out.push(div(south, place: "s"))
  }
  if east != none {
    out.push(div(east, place: "e"))
  }
  if west != none {
    out.push(div(west, place: "w"))
  }
  out
}

#let contentify-positional(args, flex: false, spacing: none, dir: ltr) = {
  if args.len() == 0 {
    none
  } else if args.len() == 1 {
    args.first()
  } else {
    if flex == true {
      _flex(..args, spacing: spacing, dir: dir)
    } else {
      args.join()
    }
  }
}

#let looks-like-number(s) = {
  type(s) == float or type(s) == int or s.match(regex("^\d+(?:\.\d+)?$")) != none
}

#let txt(s, font: none, fill: none, size: none, bold: false, italic: false, centered: true) = {
  let attrs = (:)
  if fill != none {
    attrs.insert("fill", fill)
  }
  if size != none {
    attrs.insert("size", size)
  }
  let p = text(s, ..attrs)
  let q = if bold == true {
    if is-math-content(s) {
      math.bold(p)
    } else {
      strong(p)
    }
  } else {
    p
  }
  if centered == true {
    q = _align(q, center + horizon)
  }
  q
}

#let chi(key, singleton: false, spacing: 4pt, parentheses: true, dir: ttb, ..sink) = {
  let ref = read-data("data/chinese.yml")
  let chinese = ref.at(key, default: ref.at("math practice"))
  if parentheses == true {
    chinese = "(" + chinese + ")"
  }
  let chi-size = sink.named().at("size", default: 11) - 3
  let chinese-content = div(chinese, ..sink, size: chi-size, font: "Noto Serif CJK SC")
  if singleton == true {
    chinese-content
  } else {
    stack(spacing: spacing, dir: dir, div(key, ..sink), chinese-content)
  }
}

// === Refactored div ===
#let div(
  ..sink,
  // Box & visuals
  paint: none,
  thickness: none,
  dash: none,
  width: none, height: none, bg: none, wh: none, stroke: none, radius: none, colors: none,
  wrapper: box, markup: false, inset: none, outset: none, clip: none,
  // Flow helpers
  newline: none, caption: none, caption-position: "bottom", hidden: false,
  dx: 0pt, dy: 0pt, place: none, delta: 0pt, rotate: none, circle: none, centered: false, scale: none,
  // Text
  font: none, fg: none, size: none, fill: none, bold: none, italic: none, style: none, weight: none, slant: none,
  text-mode: none, tracking: none, pad-left: none, margin-left: none, margin-bottom: none, margin-top: none, margin-right: none,
  spacing: none, baseline: none, overhang: false, dir: ltr,
  // Decorations
  underline: none, line: none, line-above: 10, line-below: 10, strike: none, text-stroke: none,
  // Alignment before box
  align: none, northwest: none, southeast: none, southwest: none, northeast: none, north: none, south: none, east: none, west: none,
  // Extras
  value: none, flex: none, class: none, template: none, no-none: false, chinese: false,
) = {
  // 1) Gather positional content (with overlays)
  let args = sink.pos()

  if chinese == true {
    font = "Noto Serif CJK SC"
    size = 0.75em
    let ref = read-data("data/chinese.yml")
    let chinese-text = ref.at(args.first(), default: ref.at("math practice"))
    args = (chinese-text,)
  }

  args = _overlay-anchors(
    args,
    north: north,
    south: south,
    east: east,
    west: west,
    ne: northeast,
    nw: northwest,
    se: southeast,
    sw: southwest,
  )

  let content = contentify-positional(args, flex: flex == true, spacing: spacing, dir: dir)

  if class != none {
    return div(content, ..resolve-class(class))
  }

  // 2) Normalize aliases and quick synonyms
  if wh != none {
    let whv = resolve-point(wh)
    width = whv
    height = whv
  }
  if fill != none {
    bg = fill
  }
  if colors != none {
    bg = colors.last()
    fg = colors.first()
  }
  if centered == true {
    align = center + horizon
  }

  // If no content but sized box requested, allow empty box
  if content == none and (width == none or height == none) {
    return
  }

  // 3) Coerce/prepare content
  let prepared = _coerce-content(
    content,
    flex: flex == true,
    spacing: spacing,
    dir: dir,
    markup: markup,
    template: template,
  )

  // 4) Text formatting
  let texted = _apply-text(
    prepared,
    font: font,
    fg: fg,
    size: size,
    style: style,
    weight: weight,
    slant: slant,
    tracking: tracking,
    text-stroke: text-stroke,
    baseline: baseline,
    overhang: overhang,
    bold: bold,
    italic: italic,
    src-content: content,
  )

  // 5) Decorations and pre-alignment
  let decorated = _apply-decorations(texted, strike: strike, underline: underline)
  let aligned = if align != none {
    _pre-align(decorated, align: align)
  } else {
    decorated
  }

  // 6) Shape / box wrapping
  let wrapped = _wrap-shape(
    aligned,
    circle: circle == true,
    bg: bg,
    stroke: stroke,
    paint: paint,
    thickness: thickness,
    dash: dash,
    radius: radius,
    inset: inset,
    outset: outset,
    clip: clip,
    width: width,
    height: height,
    wrapper: wrapper,
  )

  // 7) Post transforms
  let rotated = _apply-rotation(wrapped, rotate: rotate)
  let padded = _apply-margins(
    rotated,
    pad-left: pad-left,
    margin-left: margin-left,
    margin-right: margin-right,
    margin-top: margin-top,
    margin-bottom: margin-bottom,
  )
  let placed = _apply-placement(padded, place: place, delta: delta, dx: dx, dy: dy)
  let scaled = _apply-scale(placed, scale: scale)

  if hidden == true {
    return hide(scaled)
  }

  // 8) Caption and flow rules
  let withcap = _apply-caption(scaled, caption: caption, pos: caption-position)

  _apply-rule-and-newline(
    withcap,
    size: size,
    line: line,
    line-above: line-above,
    line-below: line-below,
    newline: newline,
  )
}

// === Convenience utilities kept from original ===
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
  div(a, ..attrs)
}

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
  div(expr, ..sink)
}

#let shape(
  body,
  items: none,
  left: none,
  right: none,
  top: none,
  bottom: none,
  spacing: 10pt,
  arrow-length: 10pt,
  arrow-spacing: 15pt,
) = {
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

