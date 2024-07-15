#import "is.typ": *

#let assert-is-color-value-object-array(args) = {
    let p = args.at(0)
    let message = "the arg must take the shape of a dictionary: (fill, value)"
    assert(is-object(p) and "value" in p and "fill" in p, message: message)
}


#let assert-is-ratio-divisible(n, ratios) = {
    assert(is-divisible(n, ratios.sum()), message: "the ratios do not evenly divide the size")
}
