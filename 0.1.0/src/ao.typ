#import "validation.typ": *
#import "resolve.typ": resolve-array

#let masterattrs = (
    line: (
        "fill",
        "stroke",
        "radius",
    ),

    circle: (
        "fill",
        "stroke",
        "radius",
    ),

    rect: (
        "fill",
        "stroke",
        "radius",
    ),
    text: (
        "fill",
        "stroke",
        "weight",
    ),
    box: (
        "width",
        "height",
        "baseline",
        "fill",
        "stroke",
        "radius",
        "inset",
        "outset",
        "clip"
    ),
    table: (
        "columns",
        "rows",
        "gutter",
        "column-gutter",
        "row-gutter",
        "fill",
        "align",
        "stroke",
        "inset"
    ),
)
#let reduce(x, callback) = {
    let store = (:)
    if is-array(x) {
        for v in x {
            let value = callback(v)
            if is-array(value) {
                store.insert(..value)
            }
        }
    }
    else if is-object(x) {
        for (k, v) in x {
            let value = callback(k, v)
            if is-array(value) {
                store.insert(..value)
            }
        }
    }
    return store
}
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
#let merge-dictionaries(..sink) = {
    let store = (:)
    let args = sink.pos().filter(is-object)
    for arg in args {
        for (k, v) in arg {
            store.insert(k, v)
        }
    }
    return store
}

#let build-attrs2(sink, key: none, ..base-sink) = {
    let kwargs = base-sink.named()
    let ref = masterattrs.at(key)
    for (k, v) in sink.named() {
        if k in ref {
            kwargs.insert(k, v)
        }
    }
    return kwargs
}

#let build-attrs(base, ..sink, key: none, aliases: false) = {
    let args = sink.pos()
    if args.len() == 0 {
        return build-attrs2(base, key: key, ..sink)
    }
    if base == none {
        base = (:)
    }

    let alias-ref = (
        inset: (
            large: 10pt,
        ),
    )
    for (k, v) in sink.named() {
        if key == none or k in masterattrs.at(key) {
            if aliases == true and k in alias-ref {
                let m = alias-ref.at(k)
                if v in m {
                    v = m.at(v)
                }
            }
            base.insert(k, v)
        }
    }
    return base
}

#let assign-existing(a, b) = {
    for (k, v) in b {
        if k in a and v != none {
            a.insert(k, v)
        }
    }
    return a
}

#let assign-fresh(a, b) = {
    for (k, v) in b {
        if k in a or v == none {
            continue
        } else {
            a.insert(k, v)
        }
    }
    return a
}

#let assign(a, b) = {
    for (k, v) in b {
        if v != none {
            a.insert(k, v)
        }
    }
}

#let create-scope(..sink) = {
    let modules = sink.pos()
    if modules.len() == 0 {
        return (:)
    }
    let base = dictionary(modules.at(0))

    for m in modules.slice(1) {
        for (k, v) in dictionary(m) {
            base.insert(k, v)
        }
    }
    return base
}

#let remove-none(x) = {
    if is-array(x) {
        return x.filter(not-none)
    }
    if is-object(x) {
        return reduce(x, (x, y) => {
                if not-none(y) {
                    return (x, y)
                }
            })
    }
}
#let filter-array(a, b) = {
    if is-array(b) {
        return a.filter(x => not b.contains(x))
    }
    todo()
}
#let filter-object(a, b) = {
    if is-array(b) {
        let store = (:)
        let keys = filter-array(a.keys(), b)
        return reduce(keys, (key) => (key, a.at(key)))
    }
    todo()
}

#let filter(a, b) = {
    if is-array(a) {
        return filter-array(a, b)
    }
    if is-object(a) {
        return filter-object(a, b)
    }
    panic("the input for filter must be of array or object")
}

#let map-filter(items, fn) = {
    let store = ()
    for item in items {
        let v = fn(item)
        if not-none(v) {
            store.push(v)
        }
    }
    return store
}

#let map(x, fn, ..sink) = {
    if is-number(x) {
        let store = ()
        for i in range(1, x + 1) {
            store.push(fn(i))
        }
        return store
    } else {
        let pos = sink.pos()
        if pos.len() > 0 {
            return x.map((x) => fn(x, ..pos))
        } else {
            return x.map(fn)
        }
    }
}

#let getter(x, ..sink) = {
    let args = sink.pos()
    if args.len() == 1 {
        return x.at(key, default: none)
    }
    let kwargs = sink.named()
    let ignore = kwargs.at("ignore", default: none)
    if ignore != none {
        return filter(x, resolve-array(ignore))
    }
}
#let every(x, fn) = {
    return x.all(fn)
}

#let resolve-sink-attrs(sink, base) = {
    let kwargs = sink.named()
    return assign-existing(base, kwargs)
}

#let find-nearest = (arr, target, ignore: none) => {
    let ignore = resolve-array(ignore)
    let closest = none
    let min_diff = none
    for num in arr {
        if num in ignore {
            continue
        }
        let diff = calc.abs(target - num)
        if min_diff == none or diff < min_diff {
            min_diff = diff
            closest = num
        }
    }
    return closest
}
#let unique(x, y) = {
    return filter-array(x, y)
}




#let trx(transform) = {
  if is-string(transform) {
      (x) => x.at(transform)
  } else if is-function(transform) {
      transform
  } else {
      identity
  }
}
#let get-max(group, transform: none) = {
  let get = trx(transform)
  let max-value = none
  for item in group {
    let value = get(item)
    if max-value == none or value > max-value {
      max-value = value
    }
  }
  max-value
}

#let get-min(group, transform: none) = {
  let get = trx(transform)
  let min-value = none
  for item in group {
    let value = get(item)
    if min-value == none or value < min-value {
      min-value = value
    }
  }
  min-value
}

// Example usage
// #let numbers = (5, 2, 8, 1, 9, 3)
// #let objects = (
  // (x: 1, y: 5),
  // (x: 3, y: 2),
  // (x: 2, y: 8)
// )

// #panic(get-min(objects, transform: "y"))
