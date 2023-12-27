import java.io.BufferedReader
import java.io.InputStreamReader

private fun dfs(
    cur: String,
    visited: HashSet<String>,
    graph: HashMap<String, HashSet<Pair<String, Int>>>,
    shortest: Boolean = true,
    cost: Int = 0
): Int {
    if (!visited.add(cur))
        return if (shortest) Int.MAX_VALUE else 0

    if (visited.size == graph.keys.size)
        return cost

    return if (shortest)
        graph[cur]!!.minOf { dfs(it.first, visited.toHashSet(), graph, true, cost + it.second) }
    else
        graph[cur]!!.maxOf { dfs(it.first, visited.toHashSet(), graph, false, cost + it.second) }
}

private fun part1(graph: HashMap<String, HashSet<Pair<String, Int>>>): Int {
    return graph.keys.minOf { dfs(it, HashSet(), graph) }
}

private fun part2(graph: HashMap<String, HashSet<Pair<String, Int>>>): Int {
    return graph.keys.maxOf { dfs(it, HashSet(), graph, false) }
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))

    val graph = HashMap<String, HashSet<Pair<String, Int>>>()
    for (line in reader.lines()) {
        val (cities, cost) = line.split(" = ")
        val (from, to) = cities.split(" to ")

        graph.getOrPut(from) { HashSet() }.add(Pair(to, cost.toInt()))
        graph.getOrPut(to) { HashSet() }.add(Pair(from, cost.toInt()))
    }

    println(part1(graph))
    println(part2(graph))
}
