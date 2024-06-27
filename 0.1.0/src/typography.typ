#let bold(s) = {
    text(str(s), weight: "bold")
}

#let h1(s, ..sink) = {
    text(str(s), weight: "bold", size: 2em, ..sink)
}

#let h2(s, ..sink) = {
    text(str(s), weight: "bold", size: 1.5em, ..sink)
}

#let sm-text = text.with(size: 0.8em)
#let md-text = text.with(size: 1.1em)
#let lg-text = text.with(size: 1.5em)
