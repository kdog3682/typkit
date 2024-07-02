#import "resolve.typ": *

#let color-match(s, color: "white") = {
    let opposites = (
        "white": "black",
    )
    let fg-fill = resolve-color(color)
    let bg-fill = resolve-color(opposites.at(color))
    let c = text(resolve-content(s), fill: fg-fill, weight: "bold")
    box(inset: 5pt, radius: 5pt, fill: bg-fill, align(c, center + horizon))
}
