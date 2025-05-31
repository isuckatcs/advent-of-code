package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

func solve(blocks []int) int {
	states := make(map[string]bool)
	iterations := 0

	for {
		state := fmt.Sprint(blocks)

		if states[state] {
			break
		}

		max_idx := 0
		for i := range len(blocks) {
			if blocks[i] > blocks[max_idx] {
				max_idx = i
			}
		}

		cnt := blocks[max_idx]
		blocks[max_idx] = 0

		for range cnt {
			max_idx = (max_idx + 1) % len(blocks)
			blocks[max_idx] += 1
		}

		iterations += 1
		states[state] = true
	}

	return iterations
}

func part1(blocks []int) int {
	return solve(blocks)
}

func part2(blocks []int) int {
	solve(blocks)
	return solve(blocks)
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	var blocks []int
	scanner.Scan()
	for _, n := range strings.Fields(scanner.Text()) {
		num, _ := strconv.Atoi(n)
		blocks = append(blocks, num)
	}

	println(part1(slices.Clone(blocks)))
	println(part2(slices.Clone(blocks)))
}
