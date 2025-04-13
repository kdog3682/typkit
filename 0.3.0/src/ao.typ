#let to-array(a) = {
    if type(a) == array {
        a
    } else if a == none {
      ()
    }
    else {
        (a,)
    }
}

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

#let filter-none(x) = {
  if type(x) == dictionary {
    let result = (:)
    for (key, value) in x.pairs() {
      if value != none {
        result.insert(key, value)
      }
    }
    return result
  } else {
    let result = ()
    for item in x {
      if item != none {
        result.push(item)
      }
    }
    return result
  }
}
