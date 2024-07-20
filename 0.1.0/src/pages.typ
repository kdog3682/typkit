#import "headers/index.typ" as headers
#import "footers/index.typ" as footers


#let dialogue = (
    paper: "us-letter",
    margin: (top: 1in, left: 1in, right: 1in, bottom: 0.85in),
    footer: footers.standard,
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


#let workbook = (
    paper: "us-letter",
    margin: (
        top: 1in,
        left: 1in,
        right: 1in,
        bottom: 1in,
    ),
    footer: footers.standard,
)
