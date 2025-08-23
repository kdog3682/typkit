#import "base.typ": arrow
#import "colors.typ"


#let ARROW = arrow(10pt)
#let EMDASH = sym.dash.em

#let ROYGBIV = (
  red,
  orange,
  yellow,
  green,
  blue,
  blue,
  purple,
)

#let ROYGBIV = colors.pallete-fun

#let ok(lightness, chroma, hue, alpha) = {
  oklch(lightness * 5%, chroma * 5%, hue * 10deg, alpha * 10%)
}

#let ROYGBIV9 = (
    ok(18, 18, 38, 9), // maroon / red
    ok(20, 15, 41, 10), // orange
    ok(20, 15, 9, 10), // light-yellow
    ok(20, 12, 52, 10), // teal (light-green)
    ok(16, 20, 87, 10), // green
    ok(20, 15, 27, 9), // bubble-gum-blue
    ok(13, 15, 21, 10), // blue
    ok(20, 15, 0, 10), // light-purple
    ok(20, 21, 1, 10), // darker purple
)


#let ALPHABET = "abcdefghijklmnopqrstuvwxyz"
#let NUMBERS = "0123456789"

#let OPERATORS = (
    "pi": sym.pi,
    // "e": sym.e,
    "tau": sym.tau,
    // "inf": sym.inf,

    "+": sym.plus,
    "-": sym.minus,
    "*": sym.ast,
    // "/": sym.slash,
    // "//": sym.floordiv,
    // "%": sym.percent,
    // "**": sym.pow,
    // "&": sym.bitand,
    // "|": sym.bitor,
    // "^": sym.xor,
    // "~": sym.bitnot,
    // "<<": sym.shl,
    // ">>": sym.shr,

    "==": sym.eq,
    // "!=": sym.ne,
    // "<": sym.lt,
    // "<=": sym.le,
    // ">": sym.gt,
    // ">=": sym.ge,

    // "&&": sym.and,
    // "||": sym.or,
    // "!": sym.not,
    //
    // "√": sym.sqrt,
    // "∑": sym.sum,
)

#let ALPHABET = "abcdefghijklmnopqrstuvwxyz"
#let NUMBERS = "0123456789"

#let PAPERS = (
  "notecard": (4in, 6in),
  "index-3x5": (3in, 5in),
  "index-4x6": (4in, 6in),
  "index-5x8": (5in, 8in),
  "business-card-us": (3.5in, 2in),
  "business-card-eu": (85mm, 55mm),
  "credit-card-id-1": (85.60mm, 53.98mm),
  "postal-hagaki": (100mm, 148mm),
  "shikishi-small": (121mm, 136mm),
  "shikishi-standard": (242mm, 273mm),
  "letter": (8.5in, 11in),
  "letter-half": (4.25in, 5.5in),
  "legal": (8.5in, 14in),
  "junior-legal": (5in, 8in),
  "half-letter": (5.5in, 8.5in),
  "statement": (5.5in, 8.5in),
  "tabloid": (11in, 17in),
  "ledger": (17in, 11in),
  "executive": (7.25in, 10.5in),
  "government-letter": (8in, 10.5in),
  "government-legal": (8.5in, 13in),
  "music": (9in, 12in),
  "octavo": (6in, 9in),
  "quarto": (8in, 10in),
  "digest": (5.5in, 8.5in),
  "pocket-book": (4.25in, 6.875in),
  "trade-paperback": (6in, 9in),
  "comic-us": (6.625in, 10.25in),
  "manga-tankobon": (115mm, 176mm),
  "zine-quarter": (4.25in, 5.5in),
  "zine-half": (5.5in, 8.5in),
  "photographic-4x6": (4in, 6in),
  "photographic-5x7": (5in, 7in),
  "photographic-8x10": (8in, 10in),
  "photographic-11x14": (11in, 14in),
  "photographic-16x20": (16in, 20in),
  "photographic-20x24": (20in, 24in),
  "square-12in": (12in, 12in),
  "kid-board-7in": (7in, 7in),
)

