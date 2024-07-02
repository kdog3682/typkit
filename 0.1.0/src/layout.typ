#import "resolve.typ": *
#import "ao.typ": *
#import "typography.typ": *
#import "validation.typ": *
#import "strokes.typ"

#let centered(c) = {
    align(c, center)
}
#let flex(..sink) = {
    let args = sink.pos()
    let opts = sink.named()
    stack(dir: ltr, spacing: 10pt, ..args.map((arg) => align(arg, horizon)))
}

#let tflex(..sink) = {
    let args = sink.pos()
    let kwargs = sink.named()
    let columns = args.len()
    table(align: horizon + center, columns: columns, stroke: none, ..kwargs, ..args)
}


#let base-flex(..args) = {
    let pos = args.pos()
    let base = (
        inset: 0pt,
        column-gutter: 20pt,
    )
    let opts = merge-dictionary(base, args.named())
    let spacing = opts.remove("spacing", default: none)
    if spacing != none {
        opts.insert("column-gutter", spacing)
    }
    table(columns: pos.len(), stroke: none, ..opts, ..pos)
}
#let tflex(..sink) = {
    base-flex(align: horizon + center, ..sink)
}



#let boxed(c, size: 20, ..sink) = {
    size = resolve-pt(size)
    box(c, width: size, height: size, ..sink)
}

/// Documentation
/// css-flex, flex, and tflex all do flex layouts.
/// the main contribution of css-flex is to have justify-content key.
/// example: "apart"
#let css-flex(..sink) = {
    let flat(arg) = {
        if is-array(arg) {
            arg.join()
        } else {
            arg
        }
    }

    let apart(col, row, length: none) = {
        if col == 0 {
            left + horizon
        } else if col == length - 1 {
            right + horizon
        } else {
            center + horizon
        }
    }

    let alignments = (
        "apart": apart
    )

    let args = sink.pos().map(flat)
    let length = args.len()
    let base = (
        inset: 0pt,
        align: "apart",
        columns: (1fr,) * length
    )
    let opts = merge-dictionary(base, sink.named())
    let align = alignments.at(opts.at("align")).with(length: length)
    let columns = opts.at("columns")
    if columns == auto {
        columns = (auto,) * length
    }
    let table-opts = (
        columns: columns, align: align, stroke: none,
        inset: opts.inset
    )
    return table(..table-opts, ..args)
}


#let simple-colon(a, b, spacing: 10pt) = {
    if is-string(a) {
        bold(a + ":")
    } else {
        bold(a)
    }
    h(spacing)
    resolve-content(b)
}

#let colon(..sink) = {
    let opts=sink.named()
    let pos=sink.pos()
    if pos.len() == 2 {
        return simple-colon(..pos, ..opts)
    }
    let joins = (
        "comma": ", ",
        "newlines": "\n"
    )

    let join = joins.at(opts.at("join", default: "comma"))
    let width = opts.at("width", default: none)
    let align = opts.at("align", default: top)

    let callback((i, el)) = {
        if is-even(i) {
            if is-string(el) {
                bold(str(el) + ":")
            } else {
                bold(el)
            }
        } else {
            if is-array(el) {
                el.join(resolve-content(join))
            } else {
                resolve-content(el)
            }
        }
    }

    let args = pos.enumerate().map(callback)
    let c = table(columns: 2, stroke: none, align: align, column-gutter: 15pt, row-gutter: 20pt, inset: 0pt, ..args)

    if exists(width) {
        box(c, width: width)
    } else {
        c
    }
}

#let bullet(items, label: none, ..sink) = {
    let items = items.map(resolve-content)
    if label == none {
        list(..items, ..sink.named())
    } else {
        bold(label)
        v(0pt)
        list(..items, indent: 5pt, ..sink.named())
    }
}

#let pill(c, ..sink) = {
    let base = (inset: 5pt, radius: 5pt, stroke: strokes.soft)
    let attrs = build-attrs(base, sink)
    box(..attrs, align(c, center + horizon))
}


#let indent(c, ind) = {
    stack(dir: ltr, h(resolve-pt(ind)), resolve-content(c), spacing: 0pt)
}
