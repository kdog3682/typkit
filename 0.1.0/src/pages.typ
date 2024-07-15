
#import "typography.typ": sm-text
#import "layout.typ": centered

#let standard-footer(page) = {
    counter(page).display(
        number => {
            let num = sm-text(number)
            let mark = [— #num —]
            centered(mark)
        },
    )
}

#let dialogue = (
    paper: "us-letter",
    margin: (top: 1in, left: 1in, right: 1in, bottom: 0.85in),
    footer: standard-footer,
)

#let standard = (
    paper: "us-letter",
    margin: (
        top: 1in,
        left: 1in,
        right: 1in,
        bottom: 0.85in,
    ),
)

#let no-margin = (
    paper: "us-letter",
    margin: (
        top: 0in,
        left: 0in,
        right: 0in,
        bottom: 0in,
    ),
)
