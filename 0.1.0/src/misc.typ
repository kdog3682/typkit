#import "is.typ": *
#import "typst.typ"
#import "resolve.typ": *

#let tern(condition, a, b) = { if is-truthy(condition) { a } else { b } }
#let identity(x) = { x }
#let exists(x) = { x != none and x != false }
#let empty(x) = { x == none }
#let unreachable() = { panic("this can never be reached") }

#let create-icon(url, size: 20) = {
    let el = image(url)
    return box(width: size * 1pt, height: size * 1pt, el)
}
#let len(x) = {
    if is-number(x) {
        return str(x).len()
    }
    return x.len()
}


/// retrieves the first arg of sink.pos() or fallback
/// fallback is required
#let get-sink(sink, fallback) = {
    let args = sink.pos()
    return if args.len() == 0 { fallback } else if args.len() == 1 { args.first() } else { args }
}



#let wrap(c, ..sink) = {
    let args = sink.pos()
    if args.at(0) == none {
        return c
    }
    if args.len() == 1 {
        args.push(args.at(0))
    }

    let ref = (
        horizontal: h,
        vertical: v
    )
    let key = sink.named().at("dir", default: "vertical")
    let resolve(x) = {
        if is-content(x) {
            x
        } else {
            let fn = ref.at(key)
            fn(resolve-pt(x))
        }
    }
    let (a, b) = args.map(resolve)
    a
    c
    b
}

#let indent-text(x, indent: 20pt) = {
    set par(first-line-indent: indent, hanging-indent: indent)
    resolve-content(x)
}


#let flip-to-bottom(c) = context {
  let h = measure(c).height
  place(bottom + left, rotate(c, 180deg))
}
#let hidden(length) = {
    hide(box(text("HI"), width: resolve-pt(length)))
}

#let nth(n, sup: bool, word: false) = {
  let ordinal-words = (
      "",
      "first",
      "second",
      "third",
      "fourth",
      "fifth",
      "sixth",
      "seventh",
      "eighth",
      "ninth",
      "tenth",
      "eleventh",
  )

  // modified from https://github.com/extua/nth
  // Conditinally define n, and if it's an integer change it to a string
  if word == true {
    return ordinal-words.at(int(n))
  }
  let ordinal-str = if type(n) == int {
    str(n)
  } else {
    n
  }
  // Main if-else tree for this function
  let ordinal-suffix = if ordinal-str.ends-with(regex("1[0-9]")) {
    "th"
  } else if ordinal-str.last() == "1" {
    "st"
  } else if ordinal-str.last() == "2" {
    "nd"
  } else if ordinal-str.last() == "3" {
    "rd"
  } else {
    "th"
  }
  // Check whether sup attribute is set, and if so return suffix superscripted
  if sup == true {
    return ordinal-str + super(ordinal-suffix)
  } else {
    return ordinal-str + ordinal-suffix
  }
}


#let n-range(..sink) = {
    let args = sink.pos().flatten()
    if is-function(args.at(-1)) {
        typst.range(args.at(0), args.at(1) + 1).map(args.at(-1))
    } else {
        typst.range(args.at(0), args.at(1) + 1)
    }
}



#let svg-test(..sink) = {
    let args = sink.pos()
    set page(width: auto, height: auto)
    if args.all(is-content) {
        args.join(v(10pt))
    }
    else if is-content(args.at(0)) {
        args.at(0)
    }
    else if is-function(args.at(0)) {
        args.at(0)(..sink.named())
    }
}

#let compass-to-degrees(key) = {
    // let reference = (
      // "north": 90deg,
      // "north-east": 45deg,
      // "east": 0deg,
      // "south-east": 315deg,
      // "south": 270deg,
      // "south-west": 225deg,
      // "west": 180deg,
      // "north-west": 135deg
    // )

    let reference = (
      "north": 90deg,
      "north-east": 45deg,
      "east": 0deg,
      "south-east": 315deg,
      "south": 270deg,
      "south-west": 225deg,
      "west": 180deg,
      "north-west": 135deg
    )
    let reference = (
      north: 90deg,
      north-west: 45deg,
      west: 0deg,
      south-west: 315deg,
      south: 270deg,
      south-east: 225deg,
      east: 180deg,
      north-east: 135deg
    )

    return reference.at(key)
}


#let get-width(x) = context {
    return measure(x).width
    // this doesnt work
}

#let shrink(c, width) = {
    block(c, width: width)
}


#let dictf(ref) = {
    let runner(key) = {
        return ref.at(key)
    }
    return runner
}

#let placed(c, align, inset: 10pt) = {
    let ref = (
        "top": (sign: 1, dir: "dy"),
        "bottom": (sign: -1, dir: "dy"),
        "left": (sign: 1, dir: "dx"),
        "right": (sign: -1, dir: "dx"),
        // "horizon": (sign: -1, dir: "dx")
        // "center": (sign: -1, dir: "dx")
    )
    let parts = repr(align).split(" + ")
    let dx = 0pt
    let dy = 0pt
    for part in parts {
        let m = ref.at(part, default: none)
        if m == none {
            continue
        }
        let (sign, dir) = m
        if dir == "dx" {
            dx = inset * sign
        } else {
            dy = inset * sign
        }
    }
    place(c, align, dx: dx, dy: dy)
}
#let get-year() = {
    datetime.today().display("[year]")
}

// #panic(get-year())

#let mirror-content(c) = {
  rotate(scale(resolve-content(c), y: -100%), 180deg)
}

#let stacked(..sink) = {
    typst.stack(dir: ltr, ..sink)
}


#let map-even-odd(items, ..sink) = {
  let args = sink.pos()
  let (even, odd) = if len(args) == 1 {
    (args.first(), none)
  } else {
    args
  }
  let callback((i, item)) = {
      if calc.even(i) == true and even != none {
          even(item)
      } else if odd != none {
          odd(item)
      }
  }
  return items.enumerate().map(callback)
}


#let opposite(value) = {
  let t = type(value)
  if t == bool {
      not value
  } else if t == int or t == float {
    if value == 1 { 0 }
    else if value == 0 { 1 }
    else { value }
  } else if t == str {
    let opposites = (
      // Single directions
      "top": "bottom",
      "bottom": "top",
      "left": "right",
      "right": "left",

      // Combined directions
      "top-left": "bottom-right",
      "top-right": "bottom-left",
      "bottom-left": "top-right",
      "bottom-right": "top-left",

      // Other positional pairs
      "above": "below",
      "below": "above",
      "inside": "outside",
      "outside": "inside",
      "front": "back",
      "back": "front",
      "in": "out",
      "out": "in",
      "up": "down",
      "down": "up",

      // Boolean strings
      "true": "false",
      "false": "true"
    )
    opposites.at(value, default: value)
  } else {
    panic("not found in opposites")
  }
}
// #panic(not not true)


#let color-match(s, color: "white") = {
    let opposites = (
        "white": "black",
    )
    let fg-fill = resolve-color(color)
    let bg-fill = resolve-color(opposites.at(color))
    let c = text(resolve-content(s), fill: fg-fill, weight: "bold")
    box(inset: 5pt, radius: 5pt, fill: bg-fill, align(c, center + horizon))
}

#let colored(x, fill, key: "stroke") = {
    let t = type(x)
    if fill == none {
        if t == str or t == int {
            return text(str(x))
        }
        return x
    }

    let paint=resolve-color(fill)
    if t == str or t == int {
        return text(str(x), fill: paint)
    } else if t == dictionary {
        let value = x.at(key, default: none)
        let value-type = type(value)

        let new-value = if value-type == stroke {
            stroke((dash: value.dash, thickness: value.thickness, paint: paint))
        } else if value-type == length {
            stroke((thickness: value, paint: paint))
        } else if value-type == color {
            stroke(paint: paint)
        } else {
            return x
        }
        x.insert(key, new-value)
        return x

    } else if t == content {
        return text(x, fill: resolve-color(fill))
    } else if t == stroke {
        return stroke((dash: x.dash, thickness: x.thickness, paint: paint))
    } else {
        unreachable()
    }
}



#let calculate-frame(numbers, k) = {
  let callback(n) = {
    let rounded = calc.floor(n / k) * k
    let value = if rounded == 0 { k } else { rounded }
    let delta = n - value
    return (
        value: value,
        delta: delta,
    )
  }

  let (a, b) = numbers.map(callback)
  return (
      dx: a.delta,
      dy: b.delta,
      width: a.value,
      height: b.value
  )
  // calculate-frame((686.5, 174), 30) // 660, 150
  // we get the closest smallest possible integer that is a multiple of k
  // use this for sizing the canvas diagram
}

