import java.io.BufferedReader
import java.io.InputStreamReader

private fun part1(line: String): Int {
    var pos = Pair(0, 0)

    val visited = HashSet<Pair<Int, Int>>()
    visited.add(pos)

    for (dir in line) {
        var (x, y) = pos

        when (dir) {
            '>' -> ++x
            '<' -> --x
            'v' -> ++y
            '^' -> --y
        }

        pos = Pair(x, y)
        visited.add(pos)
    }

    return visited.size
}

private fun part2(line: String): Int {
    val pos = mutableListOf(Pair(0, 0), Pair(0, 0))
    var i = 0

    val visited = HashSet<Pair<Int, Int>>()
    visited.add(pos[i])

    for (dir in line) {
        var (x, y) = pos[i]

        when (dir) {
            '>' -> ++x
            '<' -> --x
            'v' -> ++y
            '^' -> --y
        }

        pos[i] = Pair(x, y)
        visited.add(pos[i])
        i = (i + 1) % pos.size
    }

    return visited.size
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val line = reader.readLine()

    println(part1(line))
    println(part2(line))
}
