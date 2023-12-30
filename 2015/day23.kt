import java.io.BufferedReader
import java.io.InputStreamReader

private data class Instr(
    val kind: String,
    val o1: String,
    val o2: String?
)

private fun interpret(registers: List<Int>, instructions: List<Instr>): List<Int> {
    val regs = registers.toTypedArray()
    var ip = 0

    while (ip < instructions.size) {
        val (kind, o1, o2) = instructions[ip]

        ip += when (kind) {
            "hlf" -> {
                regs[(o1[0] - 'a')] /= 2
                1
            }

            "tpl" -> {
                regs[(o1[0] - 'a')] *= 3
                1
            }

            "inc" -> {
                ++regs[(o1[0] - 'a')]
                1
            }

            "jmp" -> {
                o1.toInt()
            }

            "jie" -> {
                if (regs[(o1[0] - 'a')] % 2 == 0) o2!!.toInt() else 1
            }

            "jio" -> {
                if (regs[(o1[0] - 'a')] == 1) o2!!.toInt() else 1
            }

            else -> throw UnsupportedOperationException("invalid instruction")
        }
    }

    return regs.toList()
}

private fun part1(instructions: List<Instr>): Int {
    return interpret(listOf(0, 0), instructions)[1]
}

private fun part2(instructions: List<Instr>): Int {
    return interpret(listOf(1, 0), instructions)[1]
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val instructions = reader.readLines().map {
        val split = it.split(" |(, )".toRegex())
        Instr(split[0], split[1], split.getOrNull(2))
    }

    println(part1(instructions))
    println(part2(instructions))
}
