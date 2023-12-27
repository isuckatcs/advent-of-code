import java.io.BufferedReader
import java.io.InputStreamReader

private fun skipUntilValid(password: String): String {
    val match = "[iol]".toRegex().find(password)

    if (match != null) {
        val i = match.range.first

        return password.slice(0 until i) +
                (password[i].code + 1).toChar() +
                "a".repeat(password.length - i - 1)
    }

    return password
}

private fun increment(password: String): String {
    val builder = StringBuilder()

    var increment = true
    for (i in password.indices.reversed()) {
        var cur = password[i]

        if (increment) {
            val overflow = cur == 'z'
            cur = if (overflow) 'a' else (cur.code + 1).toChar()
            increment = overflow
        }

        builder.append(cur)
    }

    return builder.toString().reversed()
}

private fun hasIncreasingStraight(password: String): Boolean {
    for (i in 0 until password.length - 2)
        if (password[i + 2] == password[i + 1] + 1 && password[i + 1] == password[i] + 1)
            return true

    return false
}

private fun validate(password: String): Boolean {
    return hasIncreasingStraight(password) &&
            "[^iol]*".toRegex().matches(password) &&
            "(.)\\1".toRegex().findAll(password).count() >= 2
}

private fun part1(line: String): String {
    var pw = line

    while (!validate(pw))
        pw = skipUntilValid(increment(pw))

    return pw
}

private fun part2(line: String): String {
    return part1(increment(part1(line)))
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val line = reader.readLine()

    println(part1(line))
    println(part2(line))
}
