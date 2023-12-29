import java.io.BufferedReader
import java.io.InputStreamReader

private fun isCorner(n: Int, r: Int, c: Int): Boolean {
    return (r == 0 || r == n - 1) && (c == 0 || c == n - 1)
}

private fun countAdjacentOn(grid: List<List<Char>>, r: Int, c: Int): Int {
    fun inbounds(r: Int, c: Int): Boolean {
        return 0 <= r && r < grid.size && 0 <= c && c < grid[0].size
    }

    val dr = listOf(-1, -1, -1, 0, 0, 1, 1, 1)
    val dc = listOf(-1, 0, 1, -1, 1, -1, 0, 1)

    return dr.zip(dc).count { (vr, vc) ->
        val nr = r + vr
        val nc = c + vc

        inbounds(nr, nc) && grid[nr][nc] == '#'
    }
}

private fun transform(grid: List<List<Char>>, r: Int, c: Int, fixCorners: Boolean = false): Char {
    if (fixCorners && isCorner(grid.size, r, c))
        return '#'

    val adjacentOn = countAdjacentOn(grid, r, c)

    return when (adjacentOn) {
        3 -> '#'
        2 -> grid[r][c]
        else -> '.'
    }
}

@Suppress("SameParameterValue")
private fun simulate(
    init: List<List<Char>>,
    t: Int,
    transformFunction: (List<List<Char>>, Int, Int) -> Char
): List<List<Char>> {
    var grid = init

    repeat(t) {
        grid = grid.withIndex().map { (ri, row) -> row.indices.map { transformFunction(grid, ri, it) } }
    }

    return grid
}

private fun part1(lines: List<String>): Int {
    val grid = lines.map { it.toList() }

    return simulate(grid, 100, ::transform).sumOf { it.count { c -> c == '#' } }
}

private fun part2(lines: List<String>): Int {
    val grid = lines.withIndex().map { (ri, row) ->
        row.withIndex().map { (ci, c) ->
            if (isCorner(lines.size, ri, ci)) {
                '#'
            } else {
                c
            }
        }
    }

    val simulated = simulate(grid, 100) { g, r, c -> transform(g, r, c, true) }

    return simulated.sumOf { it.count { c -> c == '#' } }
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val lines = reader.readLines()

    println(part1(lines))
    println(part2(lines))
}
