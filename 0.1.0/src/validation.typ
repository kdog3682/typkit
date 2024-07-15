#import "is.typ": *
// #import "str-utils.typ": test
#let exists(x) = { x != none and x != false }
#let empty(x) = { x == none }
#let not-none(x) = { x != none }


#let is-content-wrapper(c) = {
    return c.fields().at("body", default: none) != none
}

#let has(x, key) = {
    if is-object(x) {
        return key in x
    }
}

#let is-divisible(a, b) = {
    return calc.rem(a, b) == 0
}
