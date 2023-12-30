import java.io.BufferedReader
import java.io.InputStreamReader
import kotlin.math.max
import kotlin.math.min

private data class State(
    val isPlayerTurn: Boolean,
    val boss: List<Int>,
    val player: List<Int>,
    val shield: Int = 0,
    val poison: Int = 0,
    val recharge: Int = 0,
    val manaSpent: Int = 0
)

private data class Spell(
    val cost: Int,
    val dmg: Int,
    val heal: Int,
    val shield: Int = 0,
    val poison: Int = 0,
    val recharge: Int = 0,
)

private fun simulate(b: List<Int>, p: List<Int>, hardMode: Boolean = false): Int {
    val spells = listOf(
        Spell(53, 4, 0),
        Spell(73, 2, 2),
        Spell(113, 0, 0, shield = 6),
        Spell(173, 0, 0, poison = 6),
        Spell(229, 0, 0, recharge = 5)
    )

    val q = ArrayDeque<State>()
    q.add(State(true, b, p))

    var minMana = Int.MAX_VALUE
    while (q.isNotEmpty()) {
        var (isP, boss, player, shield, poison, recharge, manaSpent) = q.removeFirst()
        var (bHp, bAtk) = boss
        var (hp, mana) = player

        if (hardMode && !isP)
            hp -= 1

        if (hp <= 0)
            continue

        if (poison > 0) {
            bHp -= 3
            --poison
        }

        if (shield > 0)
            --shield

        if (recharge > 0) {
            mana += 101
            --recharge
        }

        if (bHp <= 0) {
            minMana = min(minMana, manaSpent)
            continue
        }

        if (!isP) {
            val newHp = hp - max(1, bAtk - if (shield > 0) 7 else 0)
            q.add(State(true, listOf(bHp, bAtk), listOf(newHp, mana), shield, poison, recharge, manaSpent))
            continue
        }

        for ((cost, dmg, heal, sh, po, re) in spells) {
            if (mana < cost)
                continue

            q.add(
                State(
                    false,
                    listOf(bHp - dmg, bAtk),
                    listOf(hp + heal, mana - cost),
                    if (shield == 0) sh else shield,
                    if (poison == 0) po else poison,
                    if (recharge == 0) re else recharge,
                    manaSpent + cost
                )
            )
        }
    }

    return minMana
}

private fun part1(boss: List<Int>): Int {
    return simulate(boss, listOf(50, 500))
}

private fun part2(boss: List<Int>): Int {
    return simulate(boss, listOf(50, 500), true)
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val boss = reader.readLines().map { "\\d+".toRegex().find(it)!!.value.toInt() }

    println(part1(boss))
    println(part2(boss))
}
