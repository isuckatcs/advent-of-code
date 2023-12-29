import java.io.BufferedReader
import java.io.InputStreamReader

@Suppress("SameParameterValue")
private fun part1(containers: List<Int>, n: Int): Int {
    val dp = Array(containers.size + 1) { Array(n + 1) { 0 } }
    dp[0][0] = 1

    for (l in 0..n) {
        for ((idx, c) in containers.withIndex()) {
            dp[idx + 1][l] = dp[idx][l]

            if (l - c >= 0)
                dp[idx + 1][l] += dp[idx][l - c]
        }
    }

    return dp[containers.size][n]
}

@Suppress("SameParameterValue")
private fun part2(containers: List<Int>, n: Int): Int {
    val paths = Array(containers.size + 1) { Array(n + 1) { listOf(listOf<Int>()) } }

    for (l in 0..n) {
        for ((idx, c) in containers.withIndex()) {
            paths[idx + 1][l] = paths[idx][l].toList()

            if (l - c >= 0)
                paths[idx + 1][l] = paths[idx + 1][l] + paths[idx][l - c].map { it + c }
        }
    }

    val validPaths = paths[containers.size][n].filter { it.sum() == n }
    val shortest = validPaths.minOf { it.size }

    return validPaths.count { it.size == shortest }
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    
    val containers = reader.readLines().map { it.toInt() }.toList()
    val n = 150

    println(part1(containers, n))
    println(part2(containers, n))
}
