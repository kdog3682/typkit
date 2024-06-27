#let slope((x1, y1), (x2, y2)) = {
    return (x2 - x1) / (y2 - y1)
}

#let magnitude(s) = {
    if s > 0 {
        1
    }
    else if s == 0 {
        0
    }
    else {
        -1
    }
}

