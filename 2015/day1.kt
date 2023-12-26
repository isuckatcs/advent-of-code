private fun part1(str: String): Int {
    var level = 0

    for (c in str) {
        when (c) {
            '(' -> ++level
            ')' -> --level
        }
    }

    return level
}

private fun part2(str: String): Int {
    var level = 0

    for ((i, c) in str.withIndex()) {
        when (c) {
            '(' -> ++level
            ')' -> --level
        }

        if (level < 0)
            return i + 1
    }

    return 0
}

fun main() {
    val line = readlnOrNull().orEmpty()

    println(part1(line))
    println(part2(line))
}
