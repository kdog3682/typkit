#import "@local/typkit:0.3.0" as tk

#let standard(page-start: 1) = context {
    set text(size: 0.65em, weight: "bold")

    let page-num = if tk.exists(page-start) {
      let num = counter(page).get().first() + page-start - 1
      let value = [Page #num]
      value
      place(value, center)
    }
}
