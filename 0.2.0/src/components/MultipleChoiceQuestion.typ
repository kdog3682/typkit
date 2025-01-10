

#import "@local/typkit:0.1.0": *
#import "base.typ": QuestionNumber

#let markup = markup-factory(marks.math)




#let annotate(question, annotations) = {

    let annotation = {
        // boxy(italic(annotations.src, size: 0.7em, fill: blue), stroke: strokes.soft)
        italic(annotations.src, size: 0.7em, fill: black, weight: "bold")
    }

    let container = base-flex(
        (content: question, align: (left + top), width: 200pt),
        (content: annotation, align: (right + bottom), width: auto),
        // column-gutter: 15pt,
        // u dont really need the column-gutter
        // because it is already aligned
        // u also dont really need it to be 1fr
        // doing 1fr ... will stretch it to the width of the parent 
        // which in this case is the root document
    )
    return box(container, inset: 10pt, stroke: strokes.soft, radius: 10pt)
    // let container = shrink({
        // lines.thin
        // shrink(question, 250pt)
        // lines.thin
        // place(annotation, bottom + right)
    // }, 300pt)
    // using block or not using block matters
    // it changes where the item is placed
    return container
    context {
        // container
        // let c = box(width: 50pt, height: 50pt, fill: black)
        let w = measure(annotation).width

        container
    }
}


#let reference = (
    schoolbook: (
        block-style: (
            
        ),
        container-style: (
            
        )
    ),
    singleton: (
        block-style: (
            // width: 235pt,
            // width: 111pt,
            // spacing: 0.3em,
            // doing this in the arguments
        ),
        container-style: (
            stroke: strokes.thin,
            inset: (
                rest: 10pt,
                bottom: 10pt, 
                    // 15pt makes it kind of stick out
                    // the bottom margin
                    // it makes the annotation look kind of weird
            ),
            radius: 5pt,
        ),
        annotation-style: arguments(
                bottom + right, dx: 5pt, dy: 5pt
        )
    ),
)

#let do-annotation(tags, src) = {
    if tags  == none {
        return 
    }

    let tags = resolve-array(tags)
    let callback(tag) = {
        // return (text(tag, size: 0.7em, style: "italic", weight: "bold", fill: white), fill: blue)
        return boxy(text(tag, size: 0.6em, style: "italic", weight: "bold", fill: white), fill: black, stroke: none)
        // return boxy(text(tag, size: 0.6em, style: "italic", weight: "bold", fill: black), fill: gray.lighten(75%), stroke: none)
    }
    return block({
        let p = tags.map(callback).join(h(3pt))

        if src != none {
            let src-content = text(src, size: 0.85em, fill: blue, weight: "bold")
            src-content
            h(5pt)
            p
        }
        else if src != none {
            context {
                let src-content = text(src, size: 0.85em, fill: blue, weight: "bold")
                src-content
                v(-10pt)
                line(stroke: strokes.soft, length: measure(src-content).width)
                v(-10pt)
                p
            }
        }
        else if src != none {
        }
        else {
            p
        }
    })
}


#let n2char(i) = {
    return "ABCDEFGHIJK".at(i)
}

#let get-letter(template, choice-index, letter-alias) = {
    if letter-alias != none {
        todo()
    } else {
        let letter = n2char(choice-index)
        let replacer(m) = {
            return letter 
        }
        return str-sub(template, "[1Aa]", replacer)
    }
}
#let enumerate-choices(choices: Array, 
    answer: none, 
    answered: false,        
    body-indent: 0.5em,       // the indent  between the prefix and body
    indent: 0.5em,            // the indent of the entire block
    numbering: "A.",          // the numbering template
    spacing: -0.3em,             // the spacing between items
    letter-alias: none,       // whether to change the letter
) = {

    let answer-index = if answered == true {
        let finder(n) = {
            return str(n) == str(answer)
        }

        choices.position(finder) 
    } else {
        none
    }

    let store = ()
    for (choice-index, choice) in choices.enumerate() {
        let prefix = bold(get-letter(numbering, choice-index, letter-alias))
        let body = markup(choice)
        let c = {
            box(prefix, width: 10pt + body-indent)
            body
        }
        if answered == true and choice-index == answer-index {
            c = box(c, outset: 5pt, radius: 8pt, fill: green.lighten(80%))
        }
        store.push(c)
    }
    return store.join(v(spacing))
    return stack(..store, spacing: 10pt + spacing)
    return pad(store.join(v(spacing)), left: indent)
}

#let MultipleChoiceQuestion(question: ContentString, answer: Integer, choices: Array, style: "schoolbook", dir: "vertical", answered: false, questionNumber: none,

    place: "lower-right",  // where to put the tags and src
    body-spacing: 0pt,     // the distance between the question & the choices
    bodyIndent: 5pt, // how much to indent the body
    width: 135pt, // the width of the question
    annotations: none,
    // body-indent: 5pt,
    tags: none,  // whether to add tags to the top-left corner
    src: none,  // whether to specify where the question came from
    asset:none,
    ..sink,

) = context {
    let question = {
        markup(question)
        v(body-spacing)
        let choicesContent = enumerate-choices(choices: choices, answer: answer, answered: answered)
        let choicesContentWithAsset = if asset!= none{
            let leftPart = asset.at("left", default: none) 
            if leftPart != none{
flex(leftPart, choicesContent)
            }
        }else{
            choicesContent
        }
        let paddedChoicesContentWithAsset = if bodyIndent!= none{
               pad(choicesContentWithAsset, left: bodyIndent)
        }else{
            choicesContentWithAsset
        }
        paddedChoicesContentWithAsset
    }
    return if annotations == none {
        if questionNumber != none {
            let q = QuestionNumber(questionNumber, mode: "alligator")
            q
            h(5pt)
            question
            
        }
        else{
 shrink(question, 215pt) 
        }
        // just looks like a standard question
        // doesnt have anything special
        // question
    } else {
        annotate(question, annotations)
    }

    let (block-style, container-style, annotation-style) = reference.at(style)
    // let natural-width =
    c = block(width: width, c)
    if container-style != none {
        let p = do-annotation(tags, src)
        if p != none {
            // c = {
                // c
                // typst.place(p, ..annotation-style)
            // }

            c = {
                stack(dir: ltr, c, align(p, top), spacing: 10pt)
                // stack(dir: ltr, c, p) // 
            }
            // if place == "above" {
               // p
               // v(-5pt)
               // c
            // } else if place == "lower-right" {
               // c
            // }
        }

        c = box(..container-style, c)
    }
    return c
}
