#let merge-dictionary(a, b, overwrite: true) = {
  for (k, v) in b {
    if type(a) == dictionary and k in a and type(v) == dictionary and type(a.at(k)) == dictionary {
      a.insert(k, merge-dictionary(a.at(k), v, overwrite: overwrite))
    } else if overwrite or k not in a {
      a.insert(k, v)
    }
  }
  return a
}


#let build-attrs(base, sink) = {
    return merge-dictionary(base, sink.named())
}


#let assign(a, b) = {
  for (k, v) in b {
      a.insert(k, v)
  }
}

#let create-scope(..sink) = {
    let modules = sink.pos()
    let base = dictionary(modules.at(0))

    for m in modules.slice(1) {
      for (k, v) in dictionary(m) {
          base.insert(k, v)
      }
    }
    return base
}

