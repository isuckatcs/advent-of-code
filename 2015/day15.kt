import java.io.BufferedReader
import java.io.InputStreamReader
import kotlin.math.max


private fun calculateHighestScore(ingredients: List<List<Int>>, ignoreCalories: Boolean = true): Int {
    var highest = 0

    for (a in 1..100) {
        for (b in 1..100 - a) {
            for (c in 1..100 - a - b) {
                for (d in 1..100 - a - b - c) {
                    if (a + b + c + d != 100)
                        continue

                    val calories =
                        a * ingredients[0][4] + b * ingredients[1][4] + c * ingredients[2][4] + d * ingredients[3][4]

                    if (!ignoreCalories && calories != 500)
                        continue

                    val properties = listOf(
                        a * ingredients[0][0] + b * ingredients[1][0] + c * ingredients[2][0] + d * ingredients[3][0],
                        a * ingredients[0][1] + b * ingredients[1][1] + c * ingredients[2][1] + d * ingredients[3][1],
                        a * ingredients[0][2] + b * ingredients[1][2] + c * ingredients[2][2] + d * ingredients[3][2],
                        a * ingredients[0][3] + b * ingredients[1][3] + c * ingredients[2][3] + d * ingredients[3][3]
                    )

                    highest = max(highest, properties.map { max(0, it) }.reduce(Int::times))
                }
            }
        }
    }

    return highest
}

private fun part1(ingredients: List<List<Int>>): Int {
    return calculateHighestScore(ingredients)
}

private fun part2(ingredients: List<List<Int>>): Int {
    return calculateHighestScore(ingredients, false)
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val ingredients = reader.readLines().map {
        "(-?\\d+)".toRegex().findAll(it)
            .map { res -> res.value.toInt() }
            .toList()
    }

    println(part1(ingredients))
    println(part2(ingredients))
}
