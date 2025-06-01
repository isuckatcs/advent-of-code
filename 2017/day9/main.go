package main

import "fmt"

func solve(input string) (int, int) {
	sum, cancelled, idx, group, garbage := 0, 0, 0, 0, false

	for idx < len(input) {
		c := input[idx]

		if c == '!' {
			idx += 1
		} else if c == '>' {
			garbage = false
		} else if garbage {
			cancelled += 1
		} else if c == '<' {
			garbage = true
		} else if c == '{' {
			group += 1
		} else if c == '}' {
			sum += group
			group -= 1
		}

		idx += 1
	}

	return sum, cancelled
}

func part1(input string) int {
	sum, _ := solve(input)
	return sum
}

func part2(input string) int {
	_, cancelled := solve(input)
	return cancelled
}

func main() {
	var input string
	fmt.Scanln(&input)

	println(part1(input))
	println(part2(input))
}
