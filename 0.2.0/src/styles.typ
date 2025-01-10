#let strokes = (
    denselyDotted: (
        thickness: 0.25pt,
        dash: "densely-dotted",
    ),
    soft: (
        thickness: 0.5pt,
        dash: "densely-dotted",
    ),
    smooth: (
        thickness: 0.5pt,
    ),
    thin: (
        thickness: 0.5pt,
        dash: "solid",
    ),
    veryThin: (
        thickness: 0.25pt,
        dash: "solid",
    ),
    // Added new stroke styles
    dashed: (
        thickness: 0.5pt,
        dash: "dashed",
    ),
    thick: (
        thickness: 1pt,
        dash: "solid",
    ),
    highlight: (
        thickness: 0.75pt,
        dash: "solid",
        paint: rgb(255, 240, 0, 50),
    ),
    accent: (
        thickness: 0.5pt,
        dash: "solid",
        paint: rgb(0, 120, 255),
    )
)

#let styles = (
    h1: (
        weight: "bold",
    ),
    questionNumber: (
        weight: "bold",
    ),
    boxes: (
        answerBox: (
            stroke: strokes.veryThin,
            inset: 5pt,
            width: 50pt,
            height: 20pt,
        ),
        questionNumber: (
            width: 20pt,
            height: 20pt,
            stroke: 0.25pt + black,
            inset: (x: 3pt, y: 3pt),
            radius: 3pt,
        ),
        // Added new box styles
        highlightBox: (
            stroke: strokes.highlight,
            inset: 8pt,
            radius: 5pt,
        ),
        noteBox: (
            stroke: strokes.dashed,
            inset: 10pt,
            radius: 8pt,
            fill: rgb(250, 250, 250),
        ),
        calloutBox: (
            stroke: strokes.thick,
            inset: 12pt,
            radius: 6pt,
            fill: rgb(245, 245, 250),
        )
    ),
    // Added new style categories
    text: (
        heading: (
            weight: "bold",
            size: 16pt,
            spacing: 5pt,
        ),
        subheading: (
            weight: "medium",
            size: 14pt,
            spacing: 3pt,
        ),
        body: (
            size: 11pt,
            spacing: 1.2em,
        ),
        caption: (
            size: 9pt,
            style: "italic",
        )
    ),
    spacing: (
        paragraph: 12pt,
        section: 24pt,
        list: 8pt,
    ),
    colors: (
        primary: rgb(0, 85, 170),
        secondary: rgb(102, 102, 102),
        accent: rgb(255, 128, 0),
        background: rgb(250, 250, 250),
    )
)
