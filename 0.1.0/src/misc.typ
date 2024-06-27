#import "is.typ": *

#let tern(condition, a, b) = { if is-truthy(condition) { a } else { b } }
#let identity(x) = { x }
#let exists(x) = { x != none and x != false }
#let empty(x) = { x == none }
#let unreachable() = { panic("this can never be reached") }

