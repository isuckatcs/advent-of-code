import java.io.BufferedReader
import java.io.InputStreamReader

private fun lookAndSaySequence(start: String, nth: Int): String {
    var seq = start

    repeat(nth) {
        val builder = StringBuilder()
        var cnt = 1

        for ((i, c) in seq.withIndex()) {
            if (i + 1 < seq.length && seq[i] == seq[i + 1]) {
                ++cnt
                continue
            }

            builder.append(cnt)
            builder.append(c)
            cnt = 1
        }

        seq = builder.toString()
    }

    return seq
}

private fun part1(line: String): Int {
    return lookAndSaySequence(line, 40).length
}

private fun part2(line: String): Int {
    return lookAndSaySequence(line, 50).length
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val line = reader.readLine()

    println(part1(line))
    println(part2(line))
}
