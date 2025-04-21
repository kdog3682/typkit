#import "is.typ": is-string, is-number, test, is-content


#let strfmt(fmt, ..args) = {
  let result = ""
  let arg_index = 0
  let i = 0
  
  while i < fmt.len() {
    if i < fmt.len() - 1 and fmt.at(i) == "%" {
      let next_char = fmt.at(i + 1)
      
      if next_char == "%" {
        // Escaped %
        result += "%"
        i += 2
      } else if next_char == "s" {
        // String
        if arg_index < args.pos().len() {
          result += str(args.pos().at(arg_index))
          arg_index += 1
        } else {
          result += "%s"
        }
        i += 2
      } else {
        // Unknown format specifier, keep it as is
        result += "%" + next_char
        i += 2
      }
    } else {
      result += fmt.at(i)
      i += 1
    }
  }
  return result
}


#let templater(s, ref) = {
    let replacement(s) = {
        let key = s.captures.first()
        return str(ref.at(key))
    }
    let pattern = "\$(\w+)"
    return s.replace(regex(pattern), replacement)
}

#let replace(s, pattern, replacement) = {
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

#let split(s, pattern: "\s+") = {
   let a = str(s).split(regex(pattern))
   if a.at(0) == "" {
       a.remove(0)
   }
   if a.at(-1) == "" {
       a.remove(-1)
   }
   return a
}


#let pluralize(n, suffix) = {
  if n == 1 {
    str(n) + " " + suffix
  } else {
    str(n) + " " + suffix + "s"
  }
}

#let match(s, r) = {
    let m = s.match(regex(r))
    if m != none {
        let len = m.captures.len()
        if len > 1 {
            m.captures
        } else if len == 1 {
            m.captures.at(0)
        } else {
            m.text
        }
    }
}

#let get-integers(s) = {
    let m = s.matches(regex("\d+"))
    return m.map((x) => int(x.text))
}
