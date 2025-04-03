#import "div.typ": div, clsx
#import "ao.typ": merge-attrs, merge
#import "base.typ": tern, exists, to-content, mirror, to-array, arrow, split
#import "layout.typ": flex, inner-grid
#import "is.typ": *
#import "patterns.typ"
#import "strokes.typ"


#let apart(length) = {
  let wrapper(col, row) = {
    if col == 0 {
      left
    } else if col == length - 1 {
      right
    } else {
      center
    }
  }
  return wrapper
}

#let eval-include(x) = {
    if is-string(x) {
        let s = "#include(\"" + x + "\")"
        eval(s, mode: "markup")
    } else {
        x
    }
}

#let hwrap(c, gap) = {
    return h(gap) + c + h(gap)
}

#let lines(n, ..sink) = {
  let fill = if sink.pos().len() == 1 {
    sink.pos().first()
  } else {
    black
  }
  for i in range(n) {
    text(lorem(3), fill: fill)
    parbreak()
  }
}

/// 
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

/// 
/// asdasd
#let create-footer(callback: align.with(center), offset: 0, template: "#sym.dash.em $number #sym.dash.em") = context {
    let page-number = counter(page).get().first() + offset
    let value = eval(templater(template, ("number": page-number)), mode: "markup")
    return callback(value)
}

#let foo() = {
set page(height: 50pt)
let callback(page-num) = {
    let a = div([Hammy Math Class], rect(), spacing: 10pt)
    div(a, page-num, spacing: 1fr, width: 50%)
}
    
    create-footer(callback: callback)
    pagebreak()
    counter(page).update(10)
    create-footer() 
    pagebreak() // this works ...
    set page(margin: 1in) // this creates a new page.
    create-footer()
}
// #foo()
