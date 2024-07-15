#import "resolve.typ": *
#import "patterns.typ"
#import "ao.typ": build-attrs

#let factory(x, newline: false, ..sink) = {
    if x == none {
        hide(text("hi"))
    } else {
        text(resolve-content(x), ..sink)
    }
    if newline == true {
        parbreak()
    }
}
#let sm-text = factory.with(size: 0.8em)
#let md-text = factory.with(size: 1.1em)
#let lg-text = factory.with(size: 1.5em)
#let h4 = factory.with(size: 1em, weight: "bold", newline: true)
#let h3 = factory.with(size: 1.2em, weight: "bold", newline: true)
#let h2 = factory.with(size: 1.5em, weight: "bold", newline: true)
#let h1 = factory.with(size: 2em, weight: "bold", newline: true)
#let bold = factory.with(weight: "bold")
#let big = factory.with(size: 1.5em)
#let medium = factory.with(size: 1.3em)
#let small = factory.with(size: 0.8em)
#let italic = factory.with(style: "italic")

#let math-bold(s) = {
    math.equation(math.bold(text(str(s))))
}

#let strike-and-replace(a, b) = {
    strike(a)
    h(3pt)
    resolve-content(b)
}

#let pattern-text(s, style: "criss-cross", size: 32pt, ..sink) = {
    let fill = dictionary(patterns).at(style)
    let attrs = build-attrs(
        weight: "bold",
        fill: fill,
        stroke: 1pt,
        key: "text",
        size: size,
        sink,
    )
    text(str(s), ..attrs)
}
