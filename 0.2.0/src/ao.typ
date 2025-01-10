#import "validation.typ": *

#let reduce(
    x, callback,
) = {
    let store = (:)
    if isArray(x) {
        for v in x {
            let value = callback(v)
            if isArray(value) {
                store.insert(..value)
            }
        }
    } else if isObject(x) {
        for (k, v) in x {
            let value = callback(k, v)
            if isArray(value) {
                store.insert(..value)
            }
        }
    }
    return store
}

#let copy(x) = {
    if type(x) == content {
        return x.clone()
    } else if type(x) == array {
        return x.map(
            v => copy(v),
        )
    } else if type(x) == dictionary {
        let store = (:)
        for (k, v) in x {
            store.insert(k, copy(v))
        }
        return store
    } else {
        return x
    }
}
#let mergeSink(
    sink, baseAttrs,
) = {
    let store = copy(baseAttrs)
    for (k, v) in sink.named() {
        store.insert(k, v)
    }
    return store
}

#let assignExisting(a, b) = {
    for (k, v) in b {
        if k in a and v != none {
            a.insert(k, v)
        }
    }
    return a
}

#let assignFresh(a, b) = {
    for (k, v) in b {
        if k in a or v == none {
            continue
        } else {
            a.insert(k, v)
        }
    }
    return a
}

#let _assign2(a, b) = {
    for (k, v) in b {
        if v != none {
            a.insert(k, v)
        }
    }
    return state
}

#let _assign3(
    state, a, b,
) = {
    if b != none {
        state.insert(a, b)
    }
    return state
}

#let assign(..sink) = {
    let args = sink.pos()
    if args.len() == 2 {
        _assign2(..args)
    } else {
        _assign3(..args)
    }
}

#let push(v) = {
    if v != none {
        store.push(v)
    }
}

#let mapFilter(items, fn) = {
    let store = ()
    for item in items {
        push(fn(item))
    }
    return store
}

#let findNearest = (
    arr, target, ignore: none,
) => {
    let ignore = resolveArray(ignore)
    let closest = none
    let minDiff = none
    for num in arr {
        if num in ignore {
            continue
        }
        let diff = calc.abs(
            target - num,
        )
        if minDiff == none or diff < minDiff {
            minDiff = diff
            closest = num
        }
    }
    return closest
}

#let _transform(transform) = {
    if isString(transform) {
        (x) => x.at(transform)
    } else if isFunction(transform) {
        transform
    }
}

#let getMaximumValue(
    group, key: none,
) = {
    let get = _transform(key)
    let maxValue = none
    for item in group {
        let value = get(item)
        if maxValue == none or value > maxValue {
            maxValue = value
        }
    }
    maxValue
}

#let getMinimumValue(
    group, key: none,
) = {
    let get = _transform(key)
    let minValue = none
    for item in group {
        let value = get(item)
        if minValue == none or value < minValue {
            minValue = value
        }
    }
    minValue
}


// #let a = (abc: 1)
// #let b = assignFresh(a, ("abc": "bye"))
// #panic(a, b)


// #let a = (abc: 1)
// #let b = mergeSink()
// #let a = (a:1)
// #panic(sys.version)
