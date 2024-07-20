#import "sizes.typ"

#let standard(page) = {
    counter(page).display(
        number => {
            let num = text(number, size: sizes.small)
            let mark = [— #num —]
            center(mark, horizon)
        },
    )
}
