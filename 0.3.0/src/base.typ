
#let exists(x) = {
  if type(x) in (dictionary, array, str) {
    return x.len() > 0
  }
  return x != none and x != false
}

#let to-content(x) = {
  if type(x) == content {
    return x
  }
  return text(str(x))
}


#let mirror(s) = {
  scale(
    x: -100%, reflow: true, text(s),
  )
}

}
#let tern(condition, a, b) = {
  if exists(condition) { a } else { b }
}

#let to-array(x) = {
    if type(x) == array {
        x
    } else if x == none {
        ()
    } else {
        (x,)
    }
}

#let split(s, pattern) = {
   let a = str(s).split(regex(pattern))
   if a.at(0) == "" {
       a.remove(0)
   }
   if a.at(-1) == "" {
       a.remove(-1)
   }
   return a
}



#let arrow(
    width, fill: black,
    angle: 0deg,
    size: 0.3em,
) = {
    let stroke = (
        paint: fill, thickness: size * 0.1,
        // dash: "densely-dotted"
    )
    let base = line(
        length: width, stroke: stroke,
    )
    let head = rotate(
        polygon.regular(
            vertices: 3, fill: fill,
            size: size,
        ), -30deg,
    )

    let arrow = box(
        {
            base
            place(
                head, dx: 0.8 * width,
                dy: -size * 0.5,
            )
        },
    )

    // v(5pt)
    // arrow
    let k = if angle in (
        90deg, 270deg,
    ) {
        v(width / 2)
    } else {
        none
    }

    k + rotate(
        arrow, angle * -1, 
    )
}
