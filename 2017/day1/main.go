package main

import "fmt"

func solve(input string, shift int) int {
	sum := 0
	l := len(input)

	for i := range l {
		c, n := input[i], input[(i+shift)%l]

		if c == n {
			sum += int(c - '0')
		}
	}

	return sum
}

func part1(input string) int {
	return solve(input, 1)
}

func part2(input string) int {
	return solve(input, len(input)/2)
}

func main() {
	var input string
	fmt.Scanln(&input)

	println(part1(input))
	println(part2(input))
}
