import java.io.BufferedReader
import java.io.InputStreamReader

private fun part1(lines: List<String>): Int {
    return lines.count {
        val includedCount = "[aeiou]".toRegex().findAll(it).count()
        val hasExcluded = ".*(ab)|(cd)|(xy)|(pq).*".toRegex().find(it) != null
        val hasDouble = "(.)\\1".toRegex().find(it) != null

        includedCount >= 3 && !hasExcluded && hasDouble
    }
}

private fun part2(lines: List<String>): Int {
    return lines.count { "(..).*(\\1)".toRegex().find(it) != null && "(.).(\\1)".toRegex().find(it) != null }
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val lines = reader.readLines()

    println(part1(lines))
    println(part2(lines))
}
