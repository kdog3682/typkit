#import "resolve.typ": *
#import "ao.typ": *
#import "misc.typ": wrap
#import "typography.typ": *
#import "validation.typ": *

#import "strokes.typ"
#import "lines.typ"
#import "typst.typ"


#let transpose(arr, width) = {
  // a helper function to swap the dimensions of a table
  array.zip(..arr.chunks(width)).join()
}

#let apply-padding(c, ..sink) = {
    let kwargs = sink.named()
    let left = kwargs.at("padding-left", default: none)
    let right = kwargs.at("padding-right", default: none)
    let x = kwargs.at("padding-x", default: none)
    if left != none { h(resolve-pt(left)) }
    else if x != none {
        h(resolve-pt(x))
    }
    c
    if right != none { h(resolve-pt(right)) }
    else if x != none {
        h(resolve-pt(x))
    }
}

#let apply-margins(c, ..sink) = {
    let kwargs = sink.named()
    let left = kwargs.at("margin-left", default: none)
    let right = kwargs.at("margin-right", default: none)
    let bottom = kwargs.at("margin-bottom", default: none)
    let top = kwargs.at("margin-top", default: none)
    let x = kwargs.at("margin-x", default: none)
    let y = kwargs.at("margin-y", default: none)
    let base = (
        left: left,
        right: right,
        x: x,
        y: y,
        bottom: bottom,
        top: top,
    )
    // let attrs = (:)
    // assign(attrs, base)
    // pad(c, ..remove-none(base))
}

#let centered(c, ..sink) = {
    let args = sink.pos()
    let alignment  =  if args.len() == 1 {
        horizon + center
    } else {
        center
    }
    align(c, alignment)
}
#let flex(..sink) = {
    let opts = sink.named()
    let aligner(c) = {
        return align(c, opts.at("align", default: horizon))
    }

    let kwargs = build-attrs((spacing: 15pt), sink)
    let args = sink.pos().map(aligner)
    stack(dir: ltr, ..args, ..kwargs)
}

#let tflex(..sink) = {
    let args = sink.pos()
    let kwargs = sink.named()
    let columns = args.len()
    table(align: horizon + center, columns: columns, stroke: none, ..kwargs, ..args)
}


#let base-flex(..args) = {

    let base = (
        inset: 0pt,
        column-gutter: 15pt,
        stroke: none, 
    )
    let pos = args.pos()
    let opts = build-attrs(base, args)
    let spacing = opts.remove("spacing", default: none)
    if spacing != none {
        opts.insert("column-gutter", spacing)
    }
    table(columns: pos.len(), ..opts, ..pos)
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


#let simple-colon(a, b, spacing: 0.5em, underline: false,
..sink) = {

    let prefix = if is-string(a) {
        bold(a + ":")
    } else {
        bold(a)
    }

    let c = resolve-content(b)
    let suffix = if underline == true {
        typst.underline(c)
    } else {
        c
    }

    let value = {
        prefix
        h(spacing)
        suffix
    }

    text(value, ..sink)
}

#let is-bolded(el) = {
    if is-string(el) {
        return false
    }
    let children = el.fields().children
    return children.any((x) => x.func() == strong)
}

#let colon(..sink) = {
    let pos=sink.pos()
    let opts=sink.named()
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
    
    let base-table-attrs = (
        column-gutter: 15pt, row-gutter: 15pt, inset: 0pt
    )
    let table-attrs = build-attrs(base-table-attrs, sink)

    let callback((i, el)) = {
        if is-even(i) {
            if is-bolded(el) {
                el
            }
            else if is-string(el) {
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
    let c = table(columns: 2, stroke: none, align: align, ..table-attrs, ..args)

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

#let indent(content, indent: 15pt, above: 5pt, below: 10pt, width: 65%, spacing: 0.6em) = {
  v(above)
  let c = block(width: width, spacing: spacing, {
        set text(size: 0.9em)
        content
  })
  stack(dir: ltr, h(indent), c, spacing: 0pt)
  v(below)
}


#let boxy(c, ..sink) = {
    let base = (
        stroke: 0.25pt + black,
        inset: (
            x: 5pt,
            y: 5pt,
        ),
        radius: 3pt,
        baseline: 25%,
    )
    let attrs = build-attrs(base, sink, key: "box", aliases: true)
    let kwargs = sink.named()
    let outer-label = kwargs.at("outer-label", default: none)
    let p = box(..attrs, resolve-math-content(c))
    if outer-label != none {
        p = box({
             centered(resolve-math-content(outer-label))
             v(-5pt)
             p
        }, stroke: none)
    }
    apply-padding(p, ..sink)
}

#let stack-boxy(a, b, inner: (:), outer: (:), spacing: 10pt) = {
    let inner-attrs = inner
    let outer-attrs = outer
    boxy(..outer-attrs, stack(align(boxy(resolve-content(a), ..inner-attrs), horizon), align(resolve-content(b), horizon), spacing: spacing, dir: ltr))
}

#let flex-table(..sink) = {
    let opts = sink.named()
    let rows = sink.pos()
    
    let base = (
        stroke: none,
        align: left + horizon,
        inset: 0pt,
        columns: rows.at(0).len(),
        column-gutter: 15pt,
        row-gutter: 10pt,
    )
    let attrs = build-attrs(base, sink, key: "table")
    table(..attrs, ..rows.flatten())
}


#let x-table(..sink) = {
    let opts = sink.named()
    let rows = sink.pos()
    
    let base = (
        inset: 10pt, 
        align: horizon + center,
    )
    let attrs = build-attrs(base, sink, key: "table")

    let dir = opts.at("dir", default: "V")
    if dir == "H" {
        let a = ()
        let b = ()
        for ((x, y)) in rows {
            a.push(x)
            b.push(y)
        }
        attrs.insert("columns", a.len())
        let elements = a + b
        table(..attrs, ..elements)
    } else {
        attrs.insert("columns", rows.at(0).len())
        table(..attrs, ..rows.flatten())
    }
}


#let title(c, line: "soft") = {
    centered(h1(resolve-content(c)))
    v(-15pt)
    dictionary(lines).at(line)
    v(10pt)
}


#let footer(c) = {
    place(box({
        lines.soft
        resolve-content(c)
    }), bottom + center)
}

// flex2 is the next version of base-flex
// it might be the next version of all the flexes
// it is the most explicit
// go with this

#let flex2(..sink) = {
    let args = sink.pos()
    let items = ()
    let align = ()
    let columns = ()
    for arg in args {
        items.push(arg.content)
        align.push(arg.at("align", default: auto))
        columns.push(arg.at("width", default: auto))
    }
    let items = args.map((x) => x.content)
    let base = (
        stroke: none
    )
    let kwargs = build-attrs(base, sink, key: "table")
    table(..items, align: align, columns: columns, ..kwargs)
}
// #simple-colon("abc", "def", size: 50pt,  underline: true)



