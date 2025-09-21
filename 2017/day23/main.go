package main

import (
	"bufio"
	"os"
	"strconv"
	"strings"
)

func write(registers map[string]int, reg string, val int) {
	registers[reg] = val
}

func read(registers map[string]int, val string) int {
	n, err := strconv.Atoi(val)
	if err == nil {
		return n
	}

	if n, found := registers[val]; found {
		return n
	}

	return 0
}

func part1(insns []string) int {
	registers := map[string]int{}
	pc := 0
	cnt := 0

	for pc >= 0 && pc < len(insns) {
		insn := insns[pc]

		split := strings.Split(insn, " ")
		op1, op2 := split[1], ""

		if len(split) > 2 {
			op2 = split[2]
		}

		switch split[0] {
		case "set":
			write(registers, op1, read(registers, op2))
		case "sub":
			write(registers, op1, read(registers, op1)-read(registers, op2))
		case "mul":
			cnt++
			write(registers, op1, read(registers, op1)*read(registers, op2))
		case "jnz":
			if read(registers, op1) != 0 {
				pc += read(registers, op2)
				continue
			}
		}

		pc++
	}

	return cnt
}

func part2() int {
	h := 0

	b := 108100
	for {
		f := 1

		d := 2
		for d != b {
			if b%d == 0 {
				f = 0
			}

			d++
		}

		if f == 0 {
			h++
		}

		if b == 125100 {
			break
		}

		b += 17
	}

	return h
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	insns := []string{}
	for scanner.Scan() {
		insns = append(insns, scanner.Text())
	}

	println(part1(insns))
	println(part2())
}
