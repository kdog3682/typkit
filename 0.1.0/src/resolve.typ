#import "is.typ": *
#import "strokes.typ"
#import "fills.typ"
#import "alignments.typ"
#import "@preview/unify:0.6.0": num



#let resolve-default(a, b) = {
    if a == none {
        b
    } else {
        a
    }
}
#let resolve-array(x) = {
    if is-array(x) {
        x
    } else if is-none(x) {
        ()
    } else {
        (x,)
    }
}

#let resolve-pt(x) = {
  if is-length(x) {
     return x
  }

  if is-string(x) {
     return eval(x)
  }
  return x * 1pt
}

#let resolve-content(x) = {
  if is-content(x) {
      return x
  }
  return text(str(x))
}


#let resolve-color(x) = {
  if is-color(x) {
      return x
  }
  let colors = (
    "red": red,
    "white": white,
    "black": black,
    "purple": purple,
    "none": black,
    "yellow": yellow,
    "blue": blue,
    "orange": orange,
    "green": green,
  )
  return colors.at(x, default: black)
}


#let resolve-math-content(x) = {
  if is-content(x) {
      return x
  }
  if is-number(x) {
    return num(x)
  }
  return text(str(x))
}


#let is-str-frac(x) = {
    return test(x, "/")
}


#let resolve-sink-content(sink) = {
    let args = sink.pos()
    let arg = args.at(0)
    if arg != none {
        return resolve-math-content(arg)
    }
}
#let resolve-stroke(x) = {
    return if is-string(x) { dictionary(strokes).at(x) } else {x }
}

#let resolve-fill(x) = {
    return if is-string(x) { dictionary(fills).at(x) } else {x }
}

#let resolve-align(x) = {
    return if is-string(x) { dictionary(alignments).at(x) } else {x }
}

