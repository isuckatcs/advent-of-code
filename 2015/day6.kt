import java.io.BufferedReader
import java.io.InputStreamReader
import kotlin.math.max

private fun part1(lines: List<String>): Int {
    val grid = MutableList(1000) { MutableList(1000) { false } }

    for (line in lines) {
        val instruction = "[a-z]+(\\s[a-z]+)?".toRegex().find(line)?.value

        val (fr, fc, tr, tc) = "\\d+,\\d+".toRegex().findAll(line).flatMap { res ->
            res.value.split(",").map {
                it.toInt()
            }.toList()
        }.toList()

        for (r in fr..tr) {
            for (c in fc..tc) {
                grid[r][c] = when (instruction) {
                    "toggle" -> !grid[r][c]
                    "turn on" -> true
                    "turn off" -> false
                    else -> false
                }
            }
        }
    }

    return grid.sumOf { r -> r.count { it } }
}

private fun part2(lines: List<String>): Int {
    val grid = MutableList(1000) { MutableList(1000) { 0 } }

    for (line in lines) {
        val instruction = "[a-z]+(\\s[a-z]+)?".toRegex().find(line)?.value

        val (fr, fc, tr, tc) = "\\d+,\\d+".toRegex().findAll(line).flatMap { res ->
            res.value.split(",").map {
                it.toInt()
            }.toList()
        }.toList()

        for (r in fr..tr) {
            for (c in fc..tc) {
                grid[r][c] += when (instruction) {
                    "toggle" -> 2
                    "turn on" -> 1
                    "turn off" -> -1
                    else -> 0
                }

                grid[r][c] = max(grid[r][c], 0)
            }
        }
    }

    return grid.sumOf { it.sum() }
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val lines = reader.readLines()

    println(part1(lines))
    println(part2(lines))
}
