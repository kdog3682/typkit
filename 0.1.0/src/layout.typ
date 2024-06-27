#let flex(..sink) = {
    let args = sink.pos()
    let opts = sink.named()
    stack(dir: ltr, spacing: 10pt, ..args.map((arg) => align(arg, horizon)))
}

