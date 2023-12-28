import java.io.BufferedReader
import java.io.InputStreamReader
import kotlin.math.min

private const val t = 2503

private fun distance(reindeer: List<Int>, t: Int): Int {
    val (d, m, s) = reindeer
    val q = t / (m + s)
    val r = t % (m + s)

    return q * m * d + min(r, m) * d
}

private fun part1(reindeer: List<List<Int>>): Int {
    return reindeer.maxOf { distance(it, t) }
}

private fun part2(reindeer: List<List<Int>>): Int {
    val leads = (1..t).flatMap { s ->
        val distances = reindeer.map { distance(it, s) }
        distances.indices.filter { distances[it] == distances.max() }
    }

    return reindeer.indices.maxOf { idx -> leads.count { it == idx } }
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val reindeer = reader.readLines().map { "\\d+".toRegex().findAll(it).map { res -> res.value.toInt() }.toList() }

    println(part1(reindeer))
    println(part2(reindeer))
}
