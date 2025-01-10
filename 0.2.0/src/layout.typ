#let todo() = {
    let pat = red
    text(
        upper("todo"), fill: pat,
        weight: "bold", size: 28pt,
    )
}
#let centered(c) = {
    v(5pt)
    align(c, center)
    v(5pt)
}

#let arrow(
    width, fill: black,
    angle: 0deg,
) = {
    let size = 0.3em
    let stroke = (
        paint: fill, thickness: size * 0.1,
        // dash: "densely-dotted"
    )
    let base = line(
        length: width, stroke: stroke,
    )
    let head = rotate(
        polygon.regular(
            vertices: 3, fill: fill,
            size: size,
        ), -30deg,
    )

    arrow = box(
        {
            base
            place(
                head, dx: 0.8 * width,
                dy: -size * 0.5,
            )
        },
    )

    rotate(
        arrow, angle * -1,
    )
}
#let boxed(c) = {
    box(
        inset: 5pt, baseline: 0pt,
        width: auto, radius: 5pt,
        stroke: strokes.denselyDotted,
        c,
    )
}
#let pill(
    c, fill: gray.lighten(70%),
) = {
    box(
        text(
            c, style: "italic",
            size: 0.7em, weight: "bold",
        ), radius: 3pt,
        fill: fill, inset: 5pt,
        width: 70pt,
    )
}
// #panic(pill([hi]))
