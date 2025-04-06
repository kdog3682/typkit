
#let merge-attrs(a, b) = {
  if a == none {
      return b
  }
  if b == none {
      return a
  }
  for (k, v) in b {
    a.insert(k, v)
  }
  return a
}



#let merge(a, b) = {
  if a == none {
      return b
  }
  if b == none {
      return a
  }
  for (k, v) in b {
    a.insert(k, v)
  }
  return a
}

#let mapfilter(store, callback) = {
    let out = ()
    for item in store {
        let s = callback(item)
        if s != none {
            out.push(s)
        }
    }
    return out
}
