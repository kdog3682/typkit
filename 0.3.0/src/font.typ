#let BASE-CHINESE-FONT = "Noto Serif CJK SC"
#let chinese-fonts = (
  "Noto Sans CJK SC",
  "Noto Sans CJK TC",
  "Noto Sans CJK JP",
  "Noto Sans CJK KR",
  "Noto Serif CJK SC",
  "Noto Serif CJK TC",
  "Noto Serif CJK JP",
  "Noto Serif CJK KR",
  "Noto Sans SC",
  "Noto Sans TC",
  "Noto Serif SC",
  "Noto Serif TC",
)

#let demo() = {
  for (i, font) in chinese-fonts.enumerate() [
    #set text(font: font, style: "italic")
    #strong[#(i + 1). #font]: #tk.chinese("math practice")
  ]
}
