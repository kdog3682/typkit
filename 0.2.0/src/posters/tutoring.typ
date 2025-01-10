#import "foo.typ": *


// #strokes
// #styles


#let k = 5
#block(inset: 20pt , width: 38.8 * k * 1pt, height: (30.5 + 25.7) * k * 1pt, stroke: strokes.denselyDotted, {

    let words = yaml("tutoring.yml")
    let super = text(words.super.english, size: 24pt, fill: red)
    let math = text(words.math.chinese, size: 24pt, fill: black)
    let jumpahead = text(words.jumpahead.chinese, size: 24pt, fill: blue)
    let learning = text(words.learning.english, size: 24pt, fill: blue)
    // let shuxue = text(chinese.shuxue)
    let g3g4 = box(text("G3 / G4 / G5", weight: "bold", size: 24pt, fill: black), inset: 5pt, stroke: (top: strokes.thin, bottom: strokes.thin))

    let a = super + math + learning
    let b = g3g4
    let c = jumpahead

    centered(stack(a,b,c, spacing: 20pt))


    
})
