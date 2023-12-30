import java.io.BufferedReader
import java.io.InputStreamReader

private fun getNSumPackages(set: List<Long>, n: Long): List<List<Long>> {
    val subsets = mutableListOf<List<Long>>()

    for (i in 0 until (1 shl set.size)) {
        val subset = mutableListOf<Long>()

        for (j in set.indices) {
            if (i and (1 shl j) != 0)
                subset.add(set[j])
        }

        if (subset.sum() == n)
            subsets.add(subset)
    }

    subsets.sortBy { it.reduce(Long::times) }
    subsets.sortBy { it.size }

    return subsets
}

private fun part1(weights: List<Long>): Long {
    val subsets = getNSumPackages(weights, weights.sum() / 3)

    for (s in subsets) {
        for (s1 in subsets) {
            val union = s.union(s1.toSet())
            if (union.size != s.size + s1.size)
                continue

            return s.reduce(Long::times)
        }
    }

    return 0
}

private fun part2(weights: List<Long>): Long {
    val subsets = getNSumPackages(weights, weights.sum() / 4)

    for (s in subsets) {
        for (s1 in subsets) {
            var union = s.union(s1.toSet())
            if (union.size != s.size + s1.size)
                continue

            for (s2 in subsets) {
                union = union.union(s2.toSet())
                if (union.size != s.size + s1.size + s2.size)
                    continue

                return s.reduce(Long::times)
            }
        }
    }

    return 0
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val weights = reader.readLines().map { it.toLong() }

    println(part1(weights))
    println(part2(weights))
}
