private fun part1(line: String): ULong {
    val (r, c) = "\\d+".toRegex().findAll(line).map { it.value.toInt() }.toList()

    val sum1ToN = { n: Int -> (n * (n + 1)) / 2 }
    val base = sum1ToN(c) + sum1ToN(c + r - 2) - sum1ToN(c - 1)

    var code = 20151125uL
    for (n in 2..base)
        code = (code * 252533uL) % 33554393uL

    return code
}

private fun part2(): Int {
    return 0
}

fun main() {
    val line = readln()

    println(part1(line))
    println(part2())
}
