#import "base.typ": *
#import "validation.typ": *

#let h4 = text.with(size: 1em, weight: "bold")
#let h3 = text.with(size: 1.2em, weight: "bold")
#let h2 = text.with(size: 1.5em, weight: "bold")
#let h1 = text.with(size: 2em, weight: "bold")
#let bigger = text.with(size: 1.5em)
#let smaller = text.with(size: 0.8em)
#let italic = text.with(style: "italic")

#let bold(x) = {
    if isMathContent(x) {
        math.bold(x)
    } else {
        text(weight: "bold", resolveContent(x))
    }
}

#let strikeAndReplace(a, b) = {
    strike(a)
    h(3pt)
    resolveContent(b)
}
