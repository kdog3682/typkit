#let isString(x) = { type(x) == str }
#let test(s, r) = {
  if isString(s) {
      return s.match(regex(r)) != none
  }
  return false
}
#let isContent(x) = { type(x) == content }
// #let isMathContent(x) = { type(x) == content and test(repr(x), "^equation")}
#let isMathContent(x) = { type(x) == content and x.func() == math.equation}
#let isNestedArray(x) = { type(x) == "array" and type(x.at(0)) == array }
#let isColor(x) = { type(x) == color }
#let isArray(x) = { type(x) == array }
#let isObject(x) = { type(x) == dictionary }
#let isNumber(x) = { type(x) == int or type(x) == float }
#let isFunction(x) = { type(x) == function }

#let exists(x) = { x != none and x != false }
#let empty(x) = { not exists(x) }
#let isTruthy(x) = {
    return x != none and x!= false and x != 0 and x.len() > 0
}
#let tern(condition, a, b) = { if isTruthy(condition) { a } else { b } }
