import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.*

private fun hasTopLevelRedValue(obj: String): Boolean {
    var level = 0
    var array = 0
    for (si in obj.indices) {
        when (obj[si]) {
            '{' -> ++level
            '}' -> --level
            '[' -> ++array
            ']' -> --array
        }

        if (level == 0 && array == 0 && obj.substring(si).startsWith(":\"red"))
            return true
    }

    return false
}

private fun part1(json: String): Int {
    return "(-?\\d+)".toRegex().findAll(json).map { it.value.toInt() }.sum()
}

private fun part2(json: String): Int {
    val subs = mutableListOf<String>()

    val s = Stack<Int>()
    for (i in json.indices) {
        when (json[i]) {
            '{' -> s.push(i)
            '}' -> {
                val obj = json.substring(s.pop() + 1, i)
                if (hasTopLevelRedValue(obj))
                    subs.add(obj)
            }
        }
    }

    subs.sortByDescending { it.length }

    var filtered = json
    while (true) {
        val (idx, sub) = filtered.findAnyOf(subs) ?: break

        filtered = filtered.slice(0 until idx) +
                filtered.slice(idx + sub.length until filtered.length)
    }

    return part1(filtered)
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val json = reader.readText()

    println(part1(json))
    println(part2(json))
}
