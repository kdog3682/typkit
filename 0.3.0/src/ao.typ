
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

