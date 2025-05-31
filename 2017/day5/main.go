package main

import (
	"bufio"
	"os"
	"strconv"
)

func part1(offsets []int) int {
	pc := 0
	steps := 0

	for pc >= 0 && pc < len(offsets) {
		inc := offsets[pc]
		offsets[pc] += 1
		pc += inc

		steps += 1
	}

	return steps
}

func part2(offsets []int) int {
	pc := 0
	steps := 0

	for pc >= 0 && pc < len(offsets) {
		inc := offsets[pc]
		if offsets[pc] >= 3 {
			offsets[pc] -= 1
		} else {
			offsets[pc] += 1
		}
		pc += inc

		steps += 1
	}

	return steps
}

func main() {
	var offsets []int

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		n, _ := strconv.Atoi(scanner.Text())
		offsets = append(offsets, n)
	}

	println(part1(append([]int{}, offsets...)))
	println(part2(append([]int{}, offsets...)))
}
