// igidrawu
// https://discord.com/channels/1054443721975922748/1262779001735479298
// 07-16-2024 

// pretty cool
// it is able to accurately display chapter titles

#let last-hd = state("body", [])
#set page(
  header: context {
    set text(size:12pt,hyphenate:false)
    let first-heading = query(
      heading.where(level: 1)
    ).find(h => h.location().page() == here().page())
    let last-heading = query(
      heading.where(level: 1)
    ).rev(
    ).find(h => h.location().page() == here().page())
    
    let header = if not first-heading == none {
      first-heading.body
      last-hd.update(last-heading.body)
    } else {
      last-hd.display()
    }

    let n = counter(page).get().first()
    if (n > 1) {
      align(center, header)
    }  
  }
)



#let section(title: none) = {
  if title != none {
    heading(title)
  }
  lorem(10)
  pagebreak()
}

#{
  outline()
  pagebreak()
  text("instead of saying 'contents', it should say first chapter too", size: 25pt, fill: red)
  section(title: "first chapter")
  section()
  section()
  section(title: "second chapter")
  section()
}
