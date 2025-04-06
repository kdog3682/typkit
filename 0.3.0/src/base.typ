
#let exists(x, ..sink) = {
  let key = if sink.pos().len() > 0 {sink.pos().first()}
  if type(x) in (dictionary, array, str) {
    if key != none {
        return x.at(key, default: none) != none
    }
    return x.len() > 0
  }
  assert(key == none, message: "key is only allowed for dicts")
  return x != none and x != false
}
#let resolve-point(x) = {
  if type(x) == length {
     return x
  }

  if type(x) == str {
     return eval(x)
  }
  return x * 1pt
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
    dy: none,
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

    let value = k + rotate(
        arrow, angle * -1, 
    )

    if dy != none {
        move(value, dy: dy)
    } else {
        value
    }
}


#let templater(s, ref) = {
    let replacement(s) = {
        let key = s.captures.first()
        return str(ref.at(key))
    }
    let pattern = "\$(\w+)"
    return s.replace(regex(pattern), replacement)
}

#let identity(s) = {
    return s
}



#let hwrap(c, gap) = {
    let a = h(resolve-point(gap))
    return a + c + a
}

#let vwrap(c, gap: 10pt) = {
    let a = v(resolve-point(gap))
    return a + c + a
}



#let join(..sink) = {
  return if sink.pos().len() == 1 {
    let el = sink.pos().first()
    assert(type(el) == array, message: "join only works for arrays")
    el.join()
  } else {
    sink.pos().join()
  }
}
