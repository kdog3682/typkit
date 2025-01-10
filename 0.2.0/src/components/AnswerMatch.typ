
#let todo() = {
    let pat = red
    text(upper("todo"), fill: pat, size: 28pt)
}
#let nrange(..sink) = {
    let args = sink.pos()
    let (a, b) = if args.len() == 2 {
        (args.at(0), args.at(1) + 1)
        
    } else if args.len() == 1 {
        (1, args.at(0) + 1)
    }
    return range(a, b).map((x) => x)
    return range(..sink).map((x) => if x >= 0 {x + 1} else {x - 1})
}
#import "MultipleChoiceQuestion.typ": MultipleChoiceQuestion
#let origin = (0, 0)
#let unit-segment = (
    origin, (1, 0),
)

#let section(c) = {
    
pagebreak()
text(c, size: 16pt, weight: "bold")
v(10pt)
}

#let centered(c) = {
  v(5pt)
  align(c, center)
  v(5pt)
}
#import "@preview/cetz:0.2.2"
#let bold = text.with(weight: "bold")
#let smaller = text.with(size: 0.75em)
#let strokes = (
    denselyDotted: (

        thickness: 0.25pt,
        dash: "densely-dotted",
    ),
    soft: (
        thickness: 0.5pt,
        dash: "densely-dotted",
        // dash: "dotted",
    ), smooth: (
        thickness: 0.5pt,
        // dash: "dotted",
    ), thin: (
        thickness: 0.5pt,
        dash: "solid",
    ), veryThin: (
        thickness: 0.25pt,
        dash: "solid",
        // paint: blue,
    ),
)

#let grayPill(c) = {
   box(bold(c, style: "italic", size: 0.7em), 
    radius: 3pt, fill: gray.lighten(70%), inset: 5pt, width: 70pt)
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
    ), questionNumber: (weight: "bold"),
    boxes: (answerBox: (
        stroke: strokes.veryThin,
        inset: 5pt,
        width: 50pt,
        height: 20pt
    ),

        questionNumber: (
            width: 20pt, height: 20pt,
        stroke: 0.25pt + black,
        inset: (
            x: 3pt,
            y: 3pt,
        ),
        radius: 3pt,
    )

    ),
)

#let qnum(n) = {
    let s = text( "Q" + str(n) + ".", fill: black, weight: "bold", size: 10pt)
    s
    return
    let s = text( "Q" + str(n), fill: white, weight: "bold", size: 10pt)
    box(..styles.boxes.questionNumber, fill: black, s)
    return
            text(
                str(n) + ".",
                ..styles.questionNumber,
            )
}
#let bottomPart(questions) = {
    let qs = questions.map(
        (x) => x.question,
    )
    let store = ()
    for (
        i, question,
    ) in questions.enumerate() {
        store.push(
        qnum(question.number)
        )
        store.push(
            question.question,
        )
        let answer = if i == 0 {
            smaller(question.answer)
        } else {
            none
        }
        let answerBox = box(
            align(answer, center), ..styles.boxes.answerBox,
        )
        if i == 0 {
            store.push(
                grid.vline(start: 0, stroke: strokes.soft),
            )
        }
        store.push(pad(answerBox, left: 10pt))
    }

    grid(..store, columns: 3, column-gutter: 5pt, row-gutter: 20pt, align: (x, y) => (
    if x > 0 { horizon + left }
    else { horizon + left }
  ))
}

#let flex(
    items, rows: none,
    columns: none,
    ..sink,
) = {
    if rows != none and columns != none {
        return
    } else if rows != none {
        let get(items) = {
            let numItems = items.len()
            let cols = if numItems <= rows {
                1
            } else {
                calc.div-euclid(
                    numItems, rows,
                )
            }
            return (
                columns: cols,
            )
        }
        let baseStyles = (
        :
        )
        grid(
            ..sink,
            ..items, ..get(items), ..baseStyles
        )
    } else if columns !=  none {
        return
        
    } else if sink.pos().len() > 0 {
        let elements = (items, arrow(20pt)) + sink.pos()
        grid(..elements, columns: elements.len(), align: horizon,
        column-gutter: 10pt)
        // stack(..elements, dir: ltr, spacing: 10pt)
    }
}

#let AnswerMatch(
    questions, enumerated: true,
    dir: "vertical",
    questionSet: none,
) = context {
    
    let b = bottomPart(
        questions
    )
    let w = measure(b).width
    let questionSetStr = "Question Set " + str(questionSet) + " " + sym.dash.em + " "
    text(
        questionSetStr + "Matching", ..styles.h1,
    )
    v(-5pt)
    line(length: w, stroke: strokes.thin)
    v(-5pt)
    block(text([_Match each answer with each question._], size: 10pt))
    // block(text([_Match each answer to each question._], size: 10pt), width: w)
    v(5pt)
    // the selection choices
    box(flex(
        questions.map(
            (x) => smaller(x.answer),
        ), rows: 2,
        
            column-gutter: 10pt, row-gutter:  10pt,
    ), radius: 5pt, stroke: strokes.smooth, inset: 5pt)
    v(5pt)
    b
}

#let FunctionInputOutput(funcExpr, input, output) = {
    let entrypoint = {
        grid(
            row-gutter: 7pt,
            align: center, boxed(
                bold(input)
            ), arrow(
                10pt, angle: -90deg,
            ),
        )
    }

    let exitpoint = {
        grid(
            row-gutter: 7pt,
            align: center, cetz.canvas(
                {
                    cetz.decorations.brace(
                        ..unit-segment,
                        amplitude: 0.3,
                        flip: true, stroke: strokes.smooth,
                    )
                }, length: 23pt,
            ), arrow(
                10pt, angle: -90deg,
            ), boxed(
                bold(output)
            ),
        )
    }
    block({

    text(funcExpr)
    let inputStatement = grayPill("a number goes in")
    let outputStatement = grayPill("a new number comes out")
    place(
        inputStatement, dx: 25.5pt,
        dy: -40pt,
    )
    place(
        outputStatement, dx: 65.5pt,
        dy: 10pt,
    )
    place(
        entrypoint, dx: 5.5pt,
        dy: -40pt,
    )
    place(
        exitpoint, dx: 36pt,
        dy: 5pt,
    )
        }, above: 50pt, below: 60pt)
}

#let funcExpr = $f(x) = x + 7$
#funcExpr performs the transformation _"add 7"_.

#let input = [6]
#let output = [13]
#FunctionInputOutput(funcExpr, input, output)

// #show math.equation: (it) => {
//   text(it, size: 0.8em)
// }
#AnswerMatch(
    (
        (
            question: $f(6)$,
            answer: $6 + 7 -> 13$, number: 1,
        ), 
        ( question: $f(3)$, answer: $3+7->10$, number: 2, ),
        ( question: $f(\c\a\k\e)$, answer: $\c\a\k\e+7$, number: 3, ),
        ( question: $f(100)$, answer: $100+7->107$, number: 4, ),
    ),
    questionSet: 1,
)

#pagebreak()
$f$ is the name of #funcExpr. The most popular function names are $f$, $g$, and $h$.

- $f(x) = x + 7$
- $g(x) = 7x$
- $h(x) = x - 7$

#MultipleChoiceQuestion(
    question: "What does $g(3)$ equal?",
    answer: 5,
    questionNumber: 5,
    choices: (20, 21, 22, 23),
)

#MultipleChoiceQuestion(
    question: "What does $f(3) + g(3)$ equal?",
    questionNumber: 6,
    choices: (30, 31, 32, 33),
)


#MultipleChoiceQuestion(
    question: "What does $f(1) + g(2) + h(3)$ equal?",
    questionNumber: 7,
    choices: (10, 11, 12, 13),
)

#pagebreak()

/// Correspondence

When you put a number into a function, a new number comes out. 

- The input is called the _independent (x)_ variable.
- The output is called the _dependent (y)_ variable because it depends on what you put in.



#MultipleChoiceQuestion(
    question: "Which function does $f(3) = 10$ come from?",
    questionNumber: 7,
    choices: (
        $f(x) = 2x - 5$,
        $f(x) = 3x - 5$,
        $f(x) = 4x - 5$,
        $f(x) = 5x - 5$,
    )
)

#MultipleChoiceQuestion(
    question: "Which function does $f(c) = c + 10$ come from?",
    questionNumber: 7,
    choices: (
        $g(a) = a + 10$,
        $f(c) = c - 10$,
        $h(x) = x + 10 - 10$,
        $j(y) = 10$,
    )
)

At the end of the day, the important part of a function is not its
name, or the letters being used, the important part is the transformation that the
function performs. In $f(c) = c + 10$, the transformation is *plus 10*. Therefore, the answer we're looking for is *(A)*.

#MultipleChoiceQuestion(
        question: "Which function does $f(3) = 10$ come from?",
        questionNumber: 7,
        choices: (
            $f(x) = 2x - 5$,
            $f(x) = 3x - 5$,
            $f(x) = 4x - 5$,
            $f(x) = 5x - 5$,
        )
    )

#section("Generating Points")
    Put something in, get something out. A number $x$ goes in, a number $y$ comes out.
    Functions are perfect for generating $(x,y)$ points.

#let funcExpr = $f(x) = x + 1$
#let funcVal = (x) => x + 1
#let xplusone = funcExpr
#let Step(c, step: none) = {
        bold("Step " + str(step) + ": ")
        c
    }
#let leftSide = for n in nrange(5) {
        smaller($f(#n) = #n + 1 -> bold(#str(funcVal(n)))$)
        v(0pt)
    }
    
#let transpose(arr, width) = {
  // a helper function to swap the dimensions of a table
  array.zip(..arr.chunks(width)).join()
}

#let pointTable(func, samples, dir: "vertical") = {
    show text: smaller
    if dir == "horizontal"{
        let width = samples.len()
        let points = samples + samples.map(func)
        table(columns: width, ..points.map(str))
    }else{
    let points = samples.map((x) => (x, func(x)).map(str)).flatten()
    show table.cell.where(y:0): strong

let rightSide = table(table.header($x$, $y$), columns:2, ..points)
rightSide
    }
}
#let values = nrange(5).map((x) => (str(x), str(funcVal(x)))).flatten()
#let rightSide =pointTable(funcVal, nrange(5)) 

#flex(
    leftSide,
    rightSide
    )

#MultipleChoiceQuestion(
    question: "The function that generates the above data is",
        questionNumber: 7,
        choices: (
            $f(x) = 1 - x$,
            $f(x) = 1 + x$,
            $f(x) = x - 1$,
            $f(x) = -x + 1$,
        )
    )
#let samples = (
    -1, 1, 3
)
#let funcLambda = (x) => x + x + x - 2
#MultipleChoiceQuestion(
    question: "Which function generates the data table shown?" ,
        questionNumber: 7,
        asset: (
          left: pointTable(funcLambda, samples)
        ),
        choices: (
            $f(x) = 3  -2x$,
            $f(x) = 2x + 3$,
            $f(x) = -3 + 2x$,
            $f(x) = 3x - 2$,
        )
    )

#section("Graphing Functions")

#let constrain(c, reference) = context {
    let width = measure(reference).width
    block(c, width:width)
}
#let foo() = {
    
  let graphContent = todo()
  let pointTableContent = pointTable(funcVal, nrange(-3, 3), dir: "horizontal")
let t = [Here are some $(x,y)$ points for #xplusone.]
    let constrainedText = constrain(t, pointTableContent)

grid(
align: center+horizon,
gutter: 10pt,

constrainedText, pointTableContent, 
[the graph], graphContent
)
}

#foo()
// #section("Linear Functions")
// #section("Quadratic Functions")
