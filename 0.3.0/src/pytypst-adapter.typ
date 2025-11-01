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
  let spec = (:)
  let _stroke = (:)
  if stroke == none {
    if paint != none {
      _stroke.paint = paint
    }
    if thickness != none {
      _stroke.thickness = thickness
    }
    if dash != none {
      _stroke.dash = dash
    } else {
      _stroke = (:)
    }
    if _stroke.len() > 0 {
      spec.stroke = _stroke
    }
  } else {
    spec.stroke = stroke
  }

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

  if centered == true {
    body = align(body, center + horizon)
  }
  if bold == true {
    body = strong(body)
  }
  _box(body, ..spec)
}



#let math-text(body, font: none, fill: none, size: none, bold: none) = {
  let content = $#body$
  return content
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

  let content = $#body$
  if bold != none {
    content = math.bold(content)
  }

  return _text(..spec, content)
}

#let text(body, weight: none, font: none, fill: none, size: none, bold: none, italic: none, hidden: false, fill-color: none) = {
  if fill-color != none {
     fill = fill-color
  }
  if weight != none {
     bold = true
  }
  if hidden == true {
    return
  }
  if type(body) == str and body.starts-with("$") and body.ends-with("$") {
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
    spec.weight = if bold == true {
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


