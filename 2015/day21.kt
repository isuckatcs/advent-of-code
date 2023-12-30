import java.io.BufferedReader
import java.io.InputStreamReader
import kotlin.math.max

private fun getItemCombinations(): List<List<Int>> {
    val swords = listOf(
        listOf(8, 4, 0),
        listOf(10, 5, 0),
        listOf(25, 6, 0),
        listOf(40, 7, 0),
        listOf(74, 8, 0)
    )

    val armor = listOf(
        listOf(0, 0, 0),
        listOf(13, 0, 1),
        listOf(31, 0, 2),
        listOf(53, 0, 3),
        listOf(75, 0, 4),
        listOf(102, 0, 5)
    )

    val rings = listOf(
        listOf(0, 0, 0),
        listOf(0, 0, 0),
        listOf(25, 1, 0),
        listOf(50, 2, 0),
        listOf(100, 3, 0),
        listOf(20, 0, 1),
        listOf(40, 0, 2),
        listOf(80, 0, 3)
    )

    val combinations = mutableListOf<List<Int>>()

    for (s in swords)
        for (a in armor)
            for (r1 in rings)
                for (r2 in rings) {
                    if (r1 == r2)
                        continue

                    val cost = s[0] + a[0] + r1[0] + r2[0]
                    val atk = s[1] + a[1] + r1[1] + r2[1]
                    val arm = s[2] + a[2] + r1[2] + r2[2]

                    combinations.add(listOf(cost, atk, arm))
                }

    return combinations
}

private fun simulate(boss: List<Int>, gear: List<Int>): Pair<Int, Int> {
    var hp = 100
    val (_, atk, arm) = gear
    var (bHp, bAtk, bArm) = boss

    while (hp > 0 && bHp > 0) {
        bHp -= max(1, atk - bArm)
        hp -= max(1, bAtk - arm)
    }

    return Pair(hp, bHp)
}

private fun part1(boss: List<Int>): Int {
    return getItemCombinations().filter { simulate(boss, it).second <= 0 }.minBy { it[0] }[0]
}

private fun part2(boss: List<Int>): Int {
    return getItemCombinations().filter {
        val (hp, bHp) = simulate(boss, it)
        bHp > 0 && hp <= 0
    }.maxBy { it[0] }[0]
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val boss = reader.readLines().map { "\\d+".toRegex().find(it)!!.value.toInt() }

    println(part1(boss))
    println(part2(boss))
}
