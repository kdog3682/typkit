#import "@local/typkit:0.2.0": *

#let template(
    doc, title: none,
) = {

    let header = none
    let footer = {
        counter(page).display(
            number => {
                let mark = flex(
                    sym.dash.em, smaller(number),
                    sym.dash.em,
                )
                align(
                    mark, center + horizon,
                )
            },
        )
    }

    set page(
        header: header,
        footer: footer,
        footer-descent: 30% + 0pt,
        header-descent: 30% + 0pt,
        width: 11in / 2,
        height: 8.5in
    )

    set par(spacing: 1em)

    tc.title(title)
}

#show template.with(title: [Fast Multiplication #sym.dash.em $12 times 13$])
#{
    speech-bubble()
}
// "~/projects/typst/mathematical/0.1.0/src/abc.typ"
#set page(
    width: 300pt,
)
#let h1(s) = context {
let m = text(s,
size: 14pt) let l =
measure(m) m v(-5pt)
line(length:
l.width, stroke:
(thickness: 0.5pt,
dash: "dotted")) }

#let strokes = (
    mbox: (
        thickness: 0.5pt,
        dash: "solid",
    ),
)
#let boxElement(arg) = {
    let c = arg.at(
        "value", default: none,
    )
    let below = arg.at(
        "below", default: none,
    )
    let main = box(
        width: 25pt, height: 25pt,
        radius: 3pt, stroke: strokes.mbox,
        inset: 10pt, c,
    )
    if below == none {
        return c
    }
    let belowContent = {
        rotate(
            sym.arrow, 270deg,
        )
        v(-5pt)
        text(
            below, size: 0.75em,
        )
    }
    place(
        belowContent, dy: 20pt,
        center,
    )
}
}) }

#let centered(c) = {
    v(5pt)
    align(c, center)
    v(5pt)
}


