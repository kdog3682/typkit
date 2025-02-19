#let template(o) = {

    let a = text(weight: "bold", o.title, size: 3em)
    let b = text(weight: "bold", o.subtitle, size: 1.5em)
    let c = image(o.image, width: 50%, height: 50%)
    let website = text(o.footer, size: 16pt )

    // set page(
    //     footer: footer,
    //     footer-descent: 30% + 0pt,
    // )

    place(a, top + center, dy: 10pt)
    place(website, bottom + center, dy: -10pt)
}


#template((title: ""))
