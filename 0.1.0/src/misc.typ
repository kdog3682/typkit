#import "is.typ": *
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
    if args.len() == 1 {
        args.push(args.at(0))
    }
    let resolve(x) = {
        if is-content(x) {
            x
        } else {
            v(resolve-pt(x))
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
