#import "is.typ": *

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
    "yellow": yellow,
    "blue": blue,
    "orange": orange,
    "green": green,
  )
  return colors.at(x)
}
