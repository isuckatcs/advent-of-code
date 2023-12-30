import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.*

private fun replacePatternAt(str: String, idx: Int, pattern: String, replacement: String): String {
    val sub = str.substring(idx)
    if (!sub.startsWith(pattern))
        return str

    return str.substring(0 until idx) + str.substring(idx).replaceFirst(pattern, replacement)
}

private fun part1(rules: List<List<String>>, molecule: String): Int {
    val uniques = molecule.indices.flatMap { idx ->
        rules.map { (p, r) -> replacePatternAt(molecule, idx, p, r) }
    }.toHashSet()

    uniques.remove(molecule)

    return uniques.size
}

private fun part2(rules: List<List<String>>, molecule: String): Int {
    val q = PriorityQueue<Pair<String, Int>> { lhs, rhs ->
        lhs.first.length - rhs.first.length
    }
    q.add(Pair(molecule, 0))

    while (q.isNotEmpty()) {
        val (cur, steps) = q.remove()

        if (cur == "e")
            return steps

        for (i in cur.indices) {
            for ((replacement, pattern) in rules) {
                val replaced = replacePatternAt(cur, i, pattern, replacement)

                if (replaced != cur) {
                    q.add(Pair(replaced, steps + 1))
                }
            }
        }
    }

    return 0
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val lines = reader.readLines().filter { it.isNotEmpty() }

    val rules = lines.take(lines.size - 1).map { it.split(" => ").toList() }
    val molecule = lines.last()

    println(part1(rules, molecule))
    println(part2(rules, molecule))
}
