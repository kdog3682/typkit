#let _text = text
#let _box = box



#let pill(
  body,
  inset: 5.5pt,
  width: none,
  height: none,
  radius: 3.5pt,
  paint: black,
  fill: none,
  thickness: 0.5pt,
  bold: false,
  dash: "densely-dotted",
  stroke: none,
  centered: true,
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
  } else {
     stroke = (:)
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
  if width != none {
    spec.width = width
  }
  if height != none {
    spec.height = height
  }
  if stroke.len() > 0 {
    spec.stroke = stroke
  }

  if centered == true {
    body = align(body, center + horizon)
  }
  if bold == true {
   body = strong(body)
  }
  _box(body, ..spec)
}



#let math-text(body, font: none, fill: none, size: none, bold: none) = {
  let spec = (:)
  if fill != none {
    spec.fill = fill
  }
  if size != none {
    spec.size = size
  }
  if font != none {
    spec.font = font
  }

  let content = math.equation(body)
  if bold != none {
    content = math.bold(content)
  }

  return _text(..spec, content)
}

#let text(body, font: none, fill: none, size: none, bold: none, italic: none) = {
  if type(body) == str and body.starts-with("$") {
    return math-text(body.slice(1, -1), font: font, fill: fill, size: size, bold: bold)
  }
  let spec = (:)
  if fill != none {
    spec.fill = fill
  }
  if size != none {
    spec.size = size
  }
  if font != none {
    spec.font = font
  }

  if bold != none {
    spec.weight = if bold {
      "bold"
    } else {
      "regular"
    }
  }
  if italic != none {
    spec.style = if italic {
      "italic"
    } else {
      "normal"
    }
  }

  return _text(..spec, body)
}


