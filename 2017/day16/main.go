package main

import (
	"fmt"
	"regexp"
	"slices"
	"strconv"
	"strings"
)

func dance(insns []string, programs []rune) string {
	spin, _ := regexp.Compile(`s(\d+)`)
	exchange, _ := regexp.Compile(`x(\d+)/(\d+)`)
	swap, _ := regexp.Compile(`p([a-z])/([a-z])`)

	for _, insn := range insns {
		kind := insn[0]
		if kind == 's' {
			match := spin.FindStringSubmatch(insn)
			n, _ := strconv.Atoi(match[1])

			split_at := len(programs) - n
			programs = append(programs[split_at:], programs[:split_at]...)
			continue
		}

		if kind == 'x' {
			match := exchange.FindStringSubmatch(insn)
			x, _ := strconv.Atoi(match[1])
			y, _ := strconv.Atoi(match[2])

			programs[x], programs[y] = programs[y], programs[x]
			continue
		}

		if kind == 'p' {
			match := swap.FindStringSubmatch(insn)
			x := rune(match[1][0])
			y := rune(match[2][0])

			x_idx := slices.Index(programs, x)
			y_idx := slices.Index(programs, y)

			programs[x_idx], programs[y_idx] = programs[y_idx], programs[x_idx]
			continue
		}
	}

	return string(programs)
}

const programs = "abcdefghijklmnop"

func part1(insns []string) string {
	return dance(insns, []rune(programs))
}

func part2(insns []string) string {
	const iterations = 1000000000
	var orders []string

	order := programs
	orders = append(orders, order)

	for range iterations {
		order = dance(insns, []rune(order))

		if slices.Contains(orders, order) {
			break
		}

		orders = append(orders, order)
	}

	return orders[iterations%len(orders)]
}

func main() {
	var input string
	fmt.Scanln(&input)

	insns := strings.Split(input, ",")

	println(part1(insns))
	println(part2(insns))
}
