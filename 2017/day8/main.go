package main

import (
	"bufio"
	"maps"
	"os"
	"regexp"
	"slices"
	"strconv"
)

func eval(insns [][]string) (map[string]int, int) {
	registers := make(map[string]int)
	alloc := 0

	for _, insn := range insns {
		reg, op, rhs, creg, cop, crhs := insn[0], insn[1], insn[2], insn[3], insn[4], insn[5]

		creg_val := registers[creg]
		crhs_val, _ := strconv.Atoi(crhs)
		var cond bool
		switch cop {
		case ">":
			cond = creg_val > crhs_val
		case "<":
			cond = creg_val < crhs_val
		case ">=":
			cond = creg_val >= crhs_val
		case "<=":
			cond = creg_val <= crhs_val
		case "==":
			cond = creg_val == crhs_val
		case "!=":
			cond = creg_val != crhs_val
		}

		if !cond {
			continue
		}

		rhs_val, _ := strconv.Atoi(rhs)
		switch op {
		case "inc":
			registers[reg] += rhs_val
		case "dec":
			registers[reg] -= rhs_val
		}

		alloc = max(alloc, registers[reg])
	}

	return registers, alloc
}

func part1(insns [][]string) int {
	registers, _ := eval(insns)

	values := slices.Sorted(maps.Values(registers))
	slices.Reverse(values)
	return values[0]
}

func part2(insns [][]string) int {
	_, alloc := eval(insns)
	return alloc
}

func main() {
	re := regexp.MustCompile(`([a-z]+)\s(inc|dec)\s(-?\d+)\sif\s([a-z]+)\s([<>=!]+)\s(-?\d+)`)

	insns := [][]string{}
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		match := re.FindStringSubmatch(scanner.Text())
		insns = append(insns, match[1:])
	}

	println(part1(insns))
	println(part2(insns))
}
