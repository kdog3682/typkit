#import "is.typ": is-string, is-number, test, is-content
#import "misc.typ": get-sink

#let str-sub(s, pattern, replacement) = {
    return s.replace(regex(pattern), replacement)
}

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

#let resolve-str(s) = {
    if is-content(s) {
        return s.body.fields().at("text")
    }
    return str(s)
}

#let split(s, ..sink) = {
   let pattern = get-sink(sink, "")
   let a = resolve-str(s).split(regex(pattern))
   if a.at(0) == "" {
       a.remove(0)
   }
   if a.at(-1) == "" {
       a.remove(-1)
   }
   return a
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

#let str-call(fn, ..sink) = {
    let args = sink.pos().map(str).join(", ")
    return fn + "(" + args + ")"
}

#let str-wrap(s, d) = {
    return d + str(s) = d
}

#let str-add(a, b) = {
    return str(a) + b
}

#let str-repeat(a, b) = {
    let el = str(a)
    let s = ""
    for i in range(0, b) {
        s += el
    }
    return s
}


#let get-integers(s) = {
    let m = s.matches(regex("\d+"))
    return m.map((x) => int(x.text))
}

#let is-exponent-content(c) = {
    test(s, "\^$")
}

#let is-factorial(s) = {
    test(s, "!$")
}

#let is-fraction(s) = {
    test(s, "!$")
}

#let is-multiplication(s) = {
    test(s, "times")
}

#let stringify(s) = {
    return json.encode(s, pretty: false)
}
