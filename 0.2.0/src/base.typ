#import "validation.typ": *


#let resolveContent(x) = {
  if isContent(x) {
      return x
  }
  return text(str(x))
}

#let toArray(x) = {
    if isArray(x) {
        x
    } else if empty(x) {
        ()
    } else {
        (x,)
    }
}

#let nrange(..sink) = {
    let args = sink.pos()
    let (a, b) = if args.len() == 2 {
        (
            args.at(0), args.at(1) + 1,
        )
    } else if args.len() == 1 {
        (
            1, args.at(0) + 1,
        )
    }
    return range(a, b).map((x) => x)
}
