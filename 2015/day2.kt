import java.io.BufferedReader
import java.io.InputStreamReader

private fun part1(lines: List<String>): Int {
    var total = 0
    for (line in lines) {
        val (l, w, h) = line.split("x").map { it.toInt() }.toList()
        val dims = intArrayOf(l * w, w * h, h * l)

        total += 2 * dims.sum() + dims.min()
    }

    return total
}

private fun part2(lines: List<String>): Int {
    var total = 0
    for (line in lines) {
        val sides = line.split("x").map { it.toInt() }.toList().sorted()

        total += 2 * sides[0] + 2 * sides[1] + sides.fold(1) { acc, i -> acc * i }
    }

    return total
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val lines = reader.readLines()

    println(part1(lines))
    println(part2(lines))
}
