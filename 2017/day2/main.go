package main

import (
	"bufio"
	"os"
	"strconv"
	"strings"
)

func min_val(nums []int) int {
	out := nums[0]
	for _, n := range nums {
		out = min(out, n)
	}
	return out
}

func max_val(nums []int) int {
	out := nums[0]
	for _, n := range nums {
		out = max(out, n)
	}
	return out
}

func part1(input [][]int) int {
	sum := 0
	for _, line := range input {
		sum += max_val(line) - min_val(line)
	}
	return sum
}

func part2(input [][]int) int {
	sum := 0
	for _, line := range input {
		for i, n := range line {
			for i2, n2 := range line {
				if i != i2 && n2%n == 0 {
					sum += n2 / n
				}
			}
		}
	}
	return sum
}

func main() {
	var input [][]int

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		var line []int

		for _, n := range strings.Fields(scanner.Text()) {
			num, _ := strconv.Atoi(n)
			line = append(line, num)
		}

		input = append(input, line)
	}

	println(part1(input))
	println(part2(input))
}
