import java.io.BufferedReader
import java.io.InputStreamReader


private fun part1(lines: List<String>): Int {
    return lines.sumOf { it.length } - lines.sumOf {
        val str = it.removeSurrounding("\"")
        var len = str.length

        len -= "(\\\\\")|(\\\\\\\\)".toRegex().findAll(str).count()
        len -= 3 * "(\\\\x[0-9a-f][0-9a-f])".toRegex().findAll(str).count()

        len
    }
}

private fun part2(lines: List<String>): Int {
    return lines.sumOf { it.length + "[\\\\\"]".toRegex().findAll(it).count() + 2 } - lines.sumOf { it.length }
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val lines = reader.readLines()

    println(part1(lines))
    println(part2(lines))
}
