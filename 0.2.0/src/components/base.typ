#import ""
#let QuestionNumber(
    n, mode: "default",
) = {
    if mode == "default" {
        return text(
            "Q" + str(n) + ".",
            fill: black, weight: "bold",
            size: 10pt,
        )
    }
    if mode == "SAT" {
        return text(
            str(n) + ".", ..styles.satQuestionNumber,
        )
    }
}
