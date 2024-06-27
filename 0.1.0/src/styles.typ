#import "util.typ"

#let base-styles = (
    slope-triangle: (
        dotted: true, circle-style: (radius: 1.5pt, fill: black),
    ),
    schoolbook: (
        window: (-10, 10, -10, 10)
    )
    // scientific: scientific,
)

// #panic(base-styles.at("slope-triangle"))
/// SOURCE: CETZ LIBRARY
#let _resolve(dict, root: none, merge: (:), base: (:)) = {
    let resolve(dict, ancestors, merge) = {
        // Merge. If both values are dictionaries, merge's values will be inserted at a lower level in this step.
        for (k, v) in merge {
            if k not in dict or not (
                type(v) == dictionary and type(dict.at(k)) == dictionary
            ) {
                dict.insert(k, v)
            }
        }

        // For each entry that is a dictionary or `auto`, travel back up the tree until it finds an entry with the same key.
        for (k, v) in dict {
            let is-dict = type(v) == dictionary
            if is-dict or v == auto {
                for ancestor in ancestors {
                    if k in ancestor {
                        // If v is auto and the ancestor's value is not auto, update v.
                        if ancestor.at(k) != auto and v == auto {
                            v = ancestor.at(k)
                            // If both values are dictionaries, merge them. Values in v overwrite its ancestor's value.
                        } else if is-dict and type(ancestor.at(k)) == dictionary {
                            v = util.merge-dictionary(ancestor.at(k), v)
                        }
                        // Retain the updated value. Because all of the ancestors have already been processed even if a v is still auto that just means the key at the highest level either is auto or doesn't exist.
                        dict.insert(k, v)
                        break
                    }
                }
            }
        }

        // Record history here so it doesn't change.
        ancestors = (dict,) + ancestors
        // Because only keys on this level have been processed, process all children of this level.
        for (k, v) in dict {
            if type(v) == dictionary {
                dict.insert(
                    k, resolve(v, ancestors, merge.at(k, default: (:))),
                )
            }
        }
        return dict
    }

    if base != (:) {
        if root != none {
            let a = (:)
            a.insert(root, base)
            base = a
        }
        dict = util.merge-dictionary(dict, base, overwrite: false)
    }
    return resolve(
        if root != none { dict.at(root) } else { dict }, if root != none { (dict,) } else { () }, merge,
    )
}

// #let dict = (
// stroke: "green",
// fill: none,
// mark: (stroke: auto, fill: "blue"),
// line: (stroke: auto, mark: auto, fill: "red")
// )
// #panic(resolve(dict, merge: (mark: (stroke: "yellow")), root: "mark"))
// if no root is specified, the dict is the root

#let get-named-sink(style) = {
    assert.eq(
        style.pos(), (), message: "Unexpected positional arguments: " + repr(style.pos()),
    )
    let style = style.named()
    return style
}

#let resolve(sink, root) = {
    let merge = get-named-sink(sink)
    return _resolve(base-styles, merge: merge, root: root)
}

