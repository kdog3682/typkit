
#let debug(child) = {
  if type(child) == content {
    panic(repr(child), child.func(), child.children, child.fields(), child.children.first())
  }
}

#let is-skippable(child) = {
  ///
  let r = repr(child)
  if r == "parbreak()" {
    return true
  }
  return false
}
