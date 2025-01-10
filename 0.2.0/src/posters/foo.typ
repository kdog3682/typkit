#let todo() = {
    let pat = red
    text(
        upper("todo"), fill: pat,
        size: 28pt,
    )
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
#let centered(c) = {
    v(5pt)
    align(c, center)
    v(5pt)
}
#let bold = text.with(
    weight: "bold",
)
#let smaller = text.with(
    size: 0.75em,
)
#let strokes = (
    denselyDotted: (
        thickness: 0.25pt,
        dash: "densely-dotted",
    ), soft: (
        thickness: 0.5pt,
        dash: "densely-dotted",
        // dash: "dotted",
    ), smooth: (
        thickness: 0.5pt,
        // dash: "dotted",
    ), thin: (
        thickness: 0.5pt,
        dash: "solid",
    ),
    veryThin: (
        thickness: 0.25pt,
        dash: "solid",
        // paint: blue,
    ),
)

#let grayPill(c) = {
    box(
        bold(
            c, style: "italic",
            size: 0.7em,
        ), radius: 3pt,
        fill: gray.lighten(70%),
        inset: 5pt, width: 70pt,
    )
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
#let styles = (
    h1: (
        weight: "bold",
    ), questionNumber: (
        weight: "bold",
    ), boxes: (
        answerBox: (
            stroke: strokes.veryThin,
            inset: 5pt, width: 50pt,
            height: 20pt,
        ), questionNumber: (
            width: 20pt, height: 20pt,
            stroke: 0.25pt + black,
            inset: (
                x: 3pt, y: 3pt,
            ), radius: 3pt,
        ),
    ),
)
