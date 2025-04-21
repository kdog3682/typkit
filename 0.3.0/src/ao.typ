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
#let maybe-dict-to-array(x) = {
  let is-dict = type(x) == dictionary
  return if is-dict == true { x.pairs() } else { x }
}
#let map(items, fn) = {
  let store = ()
  let items = maybe-dict-to-array(items)
  let as-object = type(items.first()) == dictionary
  let as-array = type(items.first()) == array
  for item in items {
    let value = if as-object == true {
      fn(..item)
    } else if as-array == true {
      fn(..item)
    } else {
      fn(item)
    }
    store.push(value)
  }
  return store
}
#let emap(items, fn, start: 0) = {
  let items = maybe-dict-to-array(items)
  return items.enumerate(start: start).map((i, el) => {
        return fn(i, el)
      })
}
#let repeated(iterable, n) = {
  let store = ()
  for i in range(n) {
    for el in to-array(iterable) {
      store.push(el)
    }
  }
  return store
}

#let assign(a, b) = {
    for (k, v) in b.pairs() {
        a.insert(k, v)
    }
}

#let partition(items, is-split-point) = {
  let result = ()
  let current-group = ()
  
  for item in items {
    if is-split-point(item) {
      if current-group.len() > 0 {
        result.push(current-group)
        current-group = ()
      }
    } else {
      current-group.push(item)
    }
  }
  
  // Add the last group if it's not empty
  if current-group.len() > 0 {
    result.push(current-group)
  }
  
  return result
}
