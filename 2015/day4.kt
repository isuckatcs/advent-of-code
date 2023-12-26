import java.io.BufferedReader
import java.io.InputStreamReader
import java.security.MessageDigest

private fun part1(line: String): Int {
    val md = MessageDigest.getInstance("MD5")

    var n = 0

    while (true) {
        val base = line + n.toString()
        val hash = md.digest(base.toByteArray()).joinToString("") { "%02x".format(it) }

        if (hash.slice(0..4).all { it == '0' })
            break

        ++n
    }

    return n
}

private fun part2(line: String): Int {
    val md = MessageDigest.getInstance("MD5")

    var n = 0

    while (true) {
        val base = line + n.toString()
        val hash = md.digest(base.toByteArray()).joinToString("") { "%02x".format(it) }

        if (hash.slice(0..5).all { it == '0' })
            break

        ++n
    }

    return n
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val line = reader.readLine()

    println(part1(line))
    println(part2(line))
}
