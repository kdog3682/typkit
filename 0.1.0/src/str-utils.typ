#import "is.typ": is-string, is-number
#import "misc.typ": get-sink

#let sub(s, pattern, replacement) = {
    return s.replace(regex(pattern), replacement)
}

#let oxford(items) = {
  let length = items.len()
  if length == 0 {
    ""
  } else if length == 1 {
    items[0]
  } else if length == 2 {
    items.join(" and ")
  } else {
    items.slice(0, -1).join(", ") + ", and " + items.at(-1)
  }
}

#let split(s, ..sink) = {
   let pattern = get-sink(sink, "")
   let a = s.split(regex(pattern))
   if a.at(0) == "" {
       a.remove(0)
   }
   if a.at(-1) == "" {
       a.remove(-1)
   }
   return a
}


#let test(s, r) = {
  if is-string(s) {
      return s.match(regex(r)) != none
  }
  return false
}

#let templater(s, ref) = {
    let callback(s) = {
        let key = s.text.slice(1)
        if is-string(ref) or is-number(ref) {
            return str(ref)
        }
        return if test(key, "^\d") {
            ref.at(int(key) - 1)
        } else {
            ref.at(key)
        }
    }
    return sub(s, "\$\w+", callback)
}




// THIS DOESNT WORK DUE TO MUTATION
#let strfmt(s, ..sink) = {
    let args = sink.pos()
    let count = 0
    let callback(key) = {
        panic(key)
        let value = str(args.at(count))
        count += 1
        return value
    }
    return s.replace(regex("%s"), callback)
}



#let has-extension(s) = {
    return test(s, "\.\w+$")
}

#let pluralize(n, suffix) = {
  if n == 1 {
    str(n) + " " + suffix
  } else {
    str(n) + " " + suffix + "s"
  }
}

#let has-newline(s) = {
    return test(s, "\n")
}

// #panic(test("abc", "a"))
