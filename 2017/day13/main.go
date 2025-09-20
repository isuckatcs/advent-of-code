package main

import (
	"bufio"
	"os"
	"strconv"
	"strings"
)

func solve(input map[int]int, delay int) (int, bool) {
	caught := false
	severity := 0

	for depth, layer_range := range input {
		picosecond := depth
		scanner_cycle := (2 + (layer_range-2)*2)

		if (delay+picosecond)%scanner_cycle == 0 {
			caught = true
			severity += depth * layer_range
		}
	}

	return severity, caught
}

func part1(input map[int]int) int {
	res, _ := solve(input, 0)
	return res
}

func part2(input map[int]int) int {
	for delay := range 10000000 {
		_, caught := solve(input, delay)

		if !caught {
			return delay
		}
	}

	return -1
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	input := make(map[int]int)
	for scanner.Scan() {
		split := strings.Split(scanner.Text(), ": ")
		layer, _ := strconv.Atoi(split[0])
		depth, _ := strconv.Atoi(split[1])

		input[layer] = depth
	}

	println(part1(input))
	println(part2(input))
}
