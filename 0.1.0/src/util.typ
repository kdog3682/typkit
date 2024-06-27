/// SOURCE: CETZ LIBRARY
/// Merge dictionary a and b and return the result
/// Prefers values of b.
///
/// - a (dictionary): Dictionary a
/// - b (dictionary): Dictionary b
/// -> dictionary
#let merge-dictionary(a, b, overwrite: true) = {
  for (k, v) in b {
    if type(a) == dictionary and k in a and type(v) == dictionary and type(a.at(k)) == dictionary {
      a.insert(k, merge-dictionary(a.at(k), v, overwrite: overwrite))
    } else if overwrite or k not in a {
      a.insert(k, v)
    }
  }
  return a
}
