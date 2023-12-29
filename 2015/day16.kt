import java.io.BufferedReader
import java.io.InputStreamReader

private val sampleMap = HashMap<String, Int>()
    get() {
        if (field.isNotEmpty())
            return field

        val samples = "children: 3\n" + "cats: 7\n" + "samoyeds: 2\n" + "pomeranians: 3\n" +
                "akitas: 0\n" + "vizslas: 0\n" + "goldfish: 5\n" + "trees: 3\n" + "cars: 2\n" + "perfumes: 1"

        samples.split("\n").associateTo(field) {
            val (type, count) = it.split(": ")
            Pair(type, count.toInt())
        }

        return field
    }

private fun findAunt(lines: List<String>, condition: (Pair<String, Int>) -> Boolean): Int {
    val aunt = lines.find { line ->
        val list = line.split("\\d: ".toRegex())[1]

        list.split(", ")
            .map {
                val (type, count) = it.split(": ")
                Pair(type, count.toInt())
            }
            .all { condition(it) }
    }

    if (aunt == null)
        return 0

    return "\\d+".toRegex().find(aunt)!!.value.toInt()
}

private fun part1(lines: List<String>): Int {
    return findAunt(lines) { (type, cnt) -> sampleMap[type] == cnt }
}

private fun part2(lines: List<String>): Int {
    return findAunt(lines) { (type, cnt) ->
        when (type) {
            "cats", "trees" -> sampleMap[type]!! < cnt
            "pomeranians", "goldfish" -> sampleMap[type]!! > cnt
            else -> sampleMap[type] == cnt
        }
    }
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val lines = reader.readLines()

    println(part1(lines))
    println(part2(lines))
}
