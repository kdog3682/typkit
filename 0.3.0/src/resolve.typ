
#let resolve-fill(x) = {
  // 2025-04-19 aicmp: this should be done with a given color scheme.
  if x == none {
    return none
  }
  if type(x) == color {
    return x
  }
  // #rgb
  if x.starts-with("#") {
    return rgb(x)
  }
  let colors = (
    "red": red,
    "white": white,
    "black": black,
    "purple": purple,
    "yellow": yellow,
    "blue": blue,
    "orange": orange,
    "green": green,
  )
  return colors.at(x, default: none)
}

#let resolve-point(x) = {
  if type(x) == length {
    return x
  }
  if x == none {
    return
  }
  if type(x) == array {
    return x.map(resolve-point)
  }

  return x * 1pt
}

#let COLOR-KEYS = (
  "fill",
  "stroke",
  "paint",
  "color",
  "background",
  "highlight",
  "tint",
)

#let LENGTH-KEYS = (
  "width",
  "height",
  "thickness",
  "inset",
  "outset",
  "spacing",
  "indent",
  "stroke-width",
  "radius",
  "gap",
  "margin",
  "padding",
)

#let resolve-kwargs(kwargs, auto-scale: false) = {
  let m = tern(auto-scale, 50, 1)
  let resolve-point-wrapper = v => resolve-point(v) * m

  // Inner runner function to handle recursion
  let runner(input) = {
    if type(input) == dictionary {
      let result = (:)
      for (k, v) in input.pairs() {
        let value = if k in COLOR-KEYS {
          resolve-fill(v)
        } else if k in LENGTH-KEYS {
          resolve-point-wrapper(v)
        } else if k == "angle" {
          resolve-angle(v)
        } else if type(v) == dictionary {
          runner(v)
        } else if k == "pos" {
            v.map(resolve-point-wrapper)
        }
        // else if type(v) == array {
        //     v.map(runner)
        // }
        else {
          v
        }
        result.insert(k, value)
      }
      return result
    } else if type(input) == array {
      return input.map(runner)
    } else {
      return input
    }
  }

  // Process the top-level dictionary
  return runner(kwargs)
}




#let COLOR-KEYS = (
  "fill",
  "stroke",
  "paint",
  "highlight",
)

#let STROKE-KEYS = (
  "thickness",
  "paint",
  "dash",
)
#let LENGTH-KEYS = (
  "width",
  "height",
  "thickness",
  "inset",
  "outset",
  "spacing",
  "indent",
  "length",
  "stroke-width",
  "radius",
  "gap",
  "margin",
  "padding",
  "pos",
)
#let resolve-stroke(v) = {
  let callback(acc, ((k, v))) = {
    let value = if k in LENGTH-KEYS {
      resolve-point(v)
    } else if k in COLOR-KEYS {
      resolve-fill(v)
    } else {
      v
    }
    acc.insert(k, value)
    return acc
  }

  return v.pairs().fold((:), callback)


}
#let resolve-style(style-sink) = {
  let kwargs = style-sink.named()
  let stroke-dict = (:)
  let base-dict = (:)
  for (k, v) in kwargs.pairs() {
    let value = if k in LENGTH-KEYS {
      resolve-point(v)
    } else if k in COLOR-KEYS {
      resolve-fill(v)
    } else if k == "stroke" {
      resolve-stroke(v)
    } else {
      v
    }

    if k in STROKE-KEYS {
      stroke-dict.insert(k, value)
    } else {
      base-dict.insert(k, value)
    }
  }

  if stroke-dict.len() > 0 {
    base-dict.insert("stroke", stroke-dict)
  }
  return base-dict
}


#let resolve-len(x) = {

  if type(x) == array {
    x.len()
  } else {
    x
  }
}
