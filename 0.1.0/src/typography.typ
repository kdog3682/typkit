#import "resolve.typ": *

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
