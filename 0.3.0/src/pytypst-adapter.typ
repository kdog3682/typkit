#let _text = text
#let _box = box



#let pill(
  body,
  inset: 3.5pt,
  radius: 3.5pt,
  paint: black,
  fill: none,
  thickness: 0.5pt,
  dash: "densely-dotted",
) = {
  let stroke = (:)
  if paint != none {
    stroke.paint = paint
  }
  if thickness != none {
    stroke.thickness = thickness
  }
  if dash != none {
    stroke.dash = dash
  }

  let spec = (:)
  if fill != none {
    spec.fill = fill
  }
  if inset != none {
    spec.inset = inset
  }
  if radius != none {
    spec.radius = radius
  }
  if stroke.len() > 0 {
    spec.stroke = stroke
  }

  _box(body, ..spec)
}


#let text(body, font: none, fill: none, size: none, bold: none, italic: none) = {
  let spec = (:)
  if fill != none { spec.fill = fill }
  if size != none { spec.size = size }
  if font != none { spec.font = font }

  if bold != none {
    spec.weight = if bold { "bold" } else { "regular" }
  }
  if italic != none {
    spec.style = if italic { "italic" } else { "normal" }
  }

  return _text(..spec, body)
}

#let math-text(body, font: none, fill: none, size: none, bold: none) = {
  let spec = (:)
  if fill != none { spec.fill = fill }
  if size != none { spec.size = size }
  if font != none { spec.font = font }

  let content = math.equation(body)
  if bold != none {
    content = math.bold(content)
  }

  return _text(..spec, content)
}

// #pill(text("hi", size: 20pt))


