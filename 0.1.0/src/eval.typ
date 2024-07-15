#import "validation.typ": is-content
#import "ao.typ": create-scope
#import "str-utils.typ": has-extension, sub
#import "marks.typ"

#let markup(x, ..modules) = {
    let scope = create-scope(..modules)
    if is-content(x) {
        return x
    }
    let s = if has-extension(x) {
        read(x)
    } else {
        x
    }

    return eval(str(s), mode: "markup", scope: scope)
}
#let markup-factory(..modules) = {
    let scope = create-scope(..modules)
    let markup(x) = {
            if is-content(x) {
                return x
            }
            let s = if has-extension(x) {
                read(x)
            } else {
                str(x)
            }
            return eval(s, mode: "markup", scope: scope)
    }
    return markup

}


#let fix-math(s) = {
    let ref = (
        "*": "dot",
        "=": "equals",
    )
    let callback(m) = {
        return " " + ref.at(m.captures.at(0)) + " "
    }
    return sub(str(s), " +([*=]) +", callback)
}

#let mathup(s) = {
    if is-content(s) {
        return s
    }
    return eval(fix-math(s), mode: "math", scope: dictionary(marks.math))
}
