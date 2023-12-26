import java.io.BufferedReader
import java.io.InputStreamReader

private data class Instruction(
    var lhs: String? = null,
    var op: String? = null,
    var rhs: String,
    var dst: String
)

private fun topologicalSort(cur: Int, dependencies: HashMap<Int, HashSet<Int>>, visited: HashSet<Int>): List<Int> {
    if (!visited.add(cur))
        return listOf()

    return dependencies[cur].orEmpty()
        .flatMap { topologicalSort(it, dependencies, visited) }
        .plus(cur)
}

private fun parseInstruction(line: String): Instruction {
    val (instruction, dst) = line.split(" -> ")
    val split = instruction.split(" ")

    return when (split.size) {
        1 -> Instruction(rhs = split[0], dst = dst)
        2 -> Instruction(op = split[0], rhs = split[1], dst = dst)
        3 -> Instruction(lhs = split[0], op = split[1], rhs = split[2], dst = dst)
        else -> throw UnsupportedOperationException("unreachable")
    }
}

private fun constructInstructionDependencyGraph(instructions: List<Instruction>): HashMap<Int, HashSet<Int>> {
    val edges = HashMap<Int, HashSet<Int>>()

    for ((i, i1) in instructions.withIndex()) {
        for ((j, i2) in instructions.withIndex()) {
            if (i == j)
                continue

            if (i2.lhs == i1.dst || i2.rhs == i1.dst)
                edges.getOrPut(i) { HashSet() }.add(j)
        }
    }

    return edges
}

private fun executeInstructions(instructions: List<Instruction>): HashMap<String, UShort> {
    val dependencies = constructInstructionDependencyGraph(instructions)
    val visited = HashSet<Int>()

    val evaluationOrder = instructions.withIndex()
        .filter { it.value.op == null }
        .flatMap { topologicalSort(it.index, dependencies, visited) }
        .reversed()

    val wires = HashMap<String, UShort>()
    for (i in evaluationOrder) {
        val (lhs, op, rhs, dst) = instructions[i]

        val rhsVal = if (rhs[0].isDigit()) rhs.toUShort() else wires[rhs]!!
        val lhsVal = if (lhs?.get(0)?.isDigit() == true) lhs.toUShort() else wires[lhs]

        wires[dst] = when (op) {
            "NOT" -> rhsVal.inv()
            "AND" -> lhsVal!! and rhsVal
            "OR" -> lhsVal!! or rhsVal
            "LSHIFT" -> (lhsVal!!.toInt() shl rhsVal.toInt()).toUShort()
            "RSHIFT" -> (lhsVal!!.toInt() ushr rhsVal.toInt()).toUShort()
            else -> rhsVal
        }
    }

    return wires
}

private fun part1(instructions: List<Instruction>): UShort {
    return executeInstructions(instructions)["a"]!!
}

private fun part2(instructions: List<Instruction>): UShort {
    val a = executeInstructions(instructions)["a"]!!

    val newInstructions = instructions.map {
        if (it.dst == "b")
            Instruction(rhs = a.toString(), dst = it.dst)
        else
            it
    }

    return executeInstructions(newInstructions)["a"]!!
}

fun main() {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    val instructions = reader.lines().map { parseInstruction(it!!) }.toList()

    println(part1(instructions))
    println(part2(instructions))
}
