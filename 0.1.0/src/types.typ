
#let RatioObjectArray = (
    (fill: "blue", value: 4),
    (fill: "purple", value: 5),
)
#let Integer = 63

#let RatioObjectArray = none
#let Integer = none
#let ContentString = none
#let Array = none
#let String = none
#let StudentObject = (
    grade: 6,
    name: "Kacper Jarecki",
)

#let DateObject = (
    season: "Autumn",
    year: 1991,
)
#let StudentSessionObject = (
    date: DateObject,
    subject: "Math",
    topics: ( "ratios", "percentages" ),
    student: StudentObject,
)
