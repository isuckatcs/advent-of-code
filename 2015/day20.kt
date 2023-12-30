import kotlin.math.sqrt

private fun getDivisors(n: Int): List<Int> {
    val divisors = mutableListOf<Int>()

    for (d in 1..sqrt(n.toDouble()).toInt()) {
        if (n % d == 0) {
            divisors.add(d)

            if (d != n / d)
                divisors.add(n / d)
        }
    }

    return divisors
}

private fun part1(target: Int): Int {
    return (1..target).find { getDivisors(it).sum() * 10 > target } ?: 0
}

private fun part2(target: Int): Int {
    return (1..target).find { h -> getDivisors(h).filter { h / it <= 50 }.sum() * 11 > target } ?: 0
}

fun main() {
    val target = readln().toInt()

    println(part1(target))
    println(part2(target))
}
