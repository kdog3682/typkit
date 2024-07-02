#import "is.typ": *
#let exists(x) = { x != none and x != false }
#let empty(x) = { x == none }


#let is-content-wrapper(c) = {
    return c.fields().at("body", default: none) != none
}
