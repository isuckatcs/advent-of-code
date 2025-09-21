package main

import (
	"fmt"
)

func part1(steps int) int {
	idx := 0
	buffer := []int{0}

	for range 2017 {
		idx = (idx + steps) % len(buffer)

		buffer = append(
			buffer[0:idx+1],
			append([]int{len(buffer)}, buffer[idx+1:]...)...,
		)
		idx++
	}

	return buffer[(idx+1)%len(buffer)]
}

func part2(steps int) int {
	max := 0

	idx := 0
	for i := range 50_000_000 {
		idx = (idx + steps) % (i + 1)

		if idx == 0 {
			max = i + 1
		}

		idx++
	}

	return max
}

func main() {
	var input int
	fmt.Scanln(&input)

	println(part1(input))
	println(part2(input))
}
