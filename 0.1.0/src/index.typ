// #import "pages.typ"
#import "types.typ": *
#import "validation.typ": *
#import "assertion.typ": *
#import "resolve.typ": *
#import "typography.typ": *
#import "misc.typ": *
#import "ao.typ": *
#import "layout.typ": *
#import "str-utils.typ": *
#import "eval.typ": *

#import "strokes.typ"
#import "sizes.typ"
#import "alignments.typ"
#import "lines.typ"
#import "ink.typ"
#import "patterns.typ"
#import "marks.typ"
#import "typst.typ"

/// @name dashbreak
/// @desc use this function when you want to have a linebreak between
/// contents. one example is mmgg sections in a story
/// 
/// @returns content
/// @param style: (str)
///     gentle: uses strokes.gentle-dots
///     tilde:  draws a large tilde
///     dots:   draws a large tilde
#let dashbreak(style: "gentle") = {
    if style == "tilde" {
        centered(text(sym.tilde, size: 20pt), )
    }
    else if style == "dots" {
        let a = line(stroke: strokes.soft)
        let b = sym.diamond.filled
        centered(tflex(a, b, a, inset: 2pt))
    }
    else if style == "gentle" {
        v(5pt)
        line(length: 100%, stroke: strokes.gentle-dots)
    }
    else if style == "topbar" {
        v(-5pt)
        line(length: 100%, stroke: strokes.soft)
        v(20pt)
    }
    else if style == "spacebar" {
        v(-5pt)
        line(length: 100%, stroke: strokes.soft)
    }
}
