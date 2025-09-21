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

func exec(insns []string, registers map[string]int, message_queue []int) []int {
	output_queue := []int{}

	pc := read(registers, "pc")
Loop:
	for pc >= 0 && pc < len(insns) {
		insn := insns[pc]

		split := strings.Split(insn, " ")
		op1, op2 := split[1], ""

		if len(split) > 2 {
			op2 = split[2]
		}

		switch split[0] {
		case "snd":
			output_queue = append(output_queue, read(registers, op1))
		case "set":
			write(registers, op1, read(registers, op2))
		case "add":
			write(registers, op1, read(registers, op1)+read(registers, op2))
		case "mul":
			write(registers, op1, read(registers, op1)*read(registers, op2))
		case "mod":
			write(registers, op1, read(registers, op1)%read(registers, op2))
		case "rcv":
			if len(message_queue) == 0 {
				break Loop
			}

			write(registers, op1, message_queue[0])
			message_queue = message_queue[1:]
		case "jgz":
			if read(registers, op1) > 0 {
				pc += read(registers, op2)
				continue
			}
		}

		pc++
	}

	registers["pc"] = pc
	return output_queue
}

func part1(insns []string) int {
	out := exec(insns, map[string]int{}, []int{})
	return out[len(out)-1]
}

func part2(insns []string) int {
	p0_regs := map[string]int{"p": 0}
	p1_regs := map[string]int{"p": 1}

	p0_msg_q := []int{}
	p1_msg_q := []int{}

	cnt := 0
	for {
		p0_msg_q, p1_msg_q = exec(insns, p0_regs, p1_msg_q), exec(insns, p1_regs, p0_msg_q)

		cnt += len(p1_msg_q)

		if len(p0_msg_q) == 0 && len(p1_msg_q) == 0 {
			break
		}
	}

	return cnt
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	insns := []string{}
	for scanner.Scan() {
		insns = append(insns, scanner.Text())
	}

	println(part1(insns))
	println(part2(insns))
}
