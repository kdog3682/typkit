

#let is-string(x) = { type(x) == str }
#let test(s, r) = {
  if is-string(s) {
      return s.match(regex(r)) != none
  }
  return false
}

#let is-content(x) = { type(x) == content }
#let is-nested-array(x) = { type(x) == "array" and type(x.at(0)) == array }
#let is-none(x) = { x ==  none }
#let is-color(x) = { type(x) == color }
#let is-array(x) = { type(x) == array }
#let is-object(x) = { type(x) == dictionary }
#let is-integer(x) = { type(x) == int }
#let is-number(x) = { type(x) == int or type(x) == float }
#let is-length(x) = { type(x) == length }

#let is-str-number(x) = { test(x, "^\d+$") }
#let is-function(x) = { type(x) == function }
#let is-truthy(x) = { x == true or x == 1 }
#let is-falsy(x) = { x == false or x == 0 }
#let is-odd(x) = { calc.odd(x) }
#let is-even(x) = { calc.even(x) }
