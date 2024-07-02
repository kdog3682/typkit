#let title(c) = {
    centered(h1(resolve-content(c)))
    v(-15pt)
    lines.soft
    v(10pt)
}

#let table(indent: none, colon: false, ..sink) = {
    let items = sink.named()
    let store = ()
    for (k, v) in items {
        if colon == true {
            k += ":"
        }
        store.push(bold(k))
        store.push(text(str(v)))
    }
    let p = typst.table(inset: 0pt, columns: 2, row-gutter: 8pt, column-gutter: 15pt, stroke: none, ..store)
    p
}
