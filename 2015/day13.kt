import java.io.BufferedReader
import java.io.InputStreamReader

// Heap's algorithm
private fun <T> getPermutations(k: Int, a: Array<T>): List<List<T>> {
    if (k == 0)
        return emptyList()

    if (k == 1)
        return listOf(a.toList())

    var out = getPermutations(k - 1, a)

    for (i in 0 until k - 1) {
        if (k % 2 == 1)
            a[i] = a[k - 1].also { a[k - 1] = a[i] }
        else
            a[0] = a[k - 1].also { a[k - 1] = a[0] }
        out = out + getPermutations(k - 1, a)
    }

    return out
}

private fun buildConnections(lines: List<String>): HashMap<String, HashMap<String, Int>> {
    val edges = HashMap<String, HashMap<String, Int>>()

    for (line in lines) {
        val split = line.split(" ")
        val n = "\\d+".toRegex().find(line)!!.value.toInt()
        val sign = when (line.contains("gain")) {
            true -> 1
            false -> -1
        }

        edges.getOrPut(split.first()) { HashMap() }[split.last().trim('.')] = sign * n
    }

    return edges
}

private fun part1(lines: List<String>): Int {
    val connections = buildConnections(lines)
    val perms = getPermutations(connections.size, connections.keys.toTypedArray())

    return perms.maxOf {
        it.withIndex().sumOf { (i, cur) ->
            val next = it[(i + 1) % it.size]
            val prev = when (i) {
                0 -> it.last()
                else -> it[i - 1]
            }

            (connections[cur]!![prev] ?: 0) + (connections[cur]!![next] ?: 0)
        }
    }
}

private fun part2(lines: List<String>): Int {
    return part1(lines + "Self 0 Self")
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val lines = reader.readLines()

    println(part1(lines))
    println(part2(lines))
}
