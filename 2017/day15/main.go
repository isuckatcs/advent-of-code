package main

import (
	"bufio"
	"os"
	"regexp"
	"strconv"
)

const a_factor = 16807
const b_factor = 48271
const mod = 2147483647

func part1(a_first uint64, b_first uint64) int {
	matches := 0

	for range 40_000_000 {
		a_first = (a_first * a_factor) % mod
		b_first = (b_first * b_factor) % mod

		const mask = (1 << 16) - 1
		if a_first&mask == b_first&mask {
			matches++
		}
	}

	return matches
}

func part2(a_first uint64, b_first uint64) int {
	matches := 0

	for range 5_000_000 {
		for {
			a_first = (a_first * a_factor) % mod

			if a_first%4 == 0 {
				break
			}
		}

		for {
			b_first = (b_first * b_factor) % mod

			if b_first%8 == 0 {
				break
			}
		}

		const mask = (1 << 16) - 1
		if a_first&mask == b_first&mask {
			matches++
		}
	}

	return matches
}

func main() {
	re := regexp.MustCompile(`\d+`)

	scanner := bufio.NewScanner(os.Stdin)

	scanner.Scan()
	a_starter, _ := strconv.ParseUint(re.FindString(scanner.Text()), 10, 64)

	scanner.Scan()
	b_starter, _ := strconv.ParseUint(re.FindString(scanner.Text()), 10, 64)

	println(part1(a_starter, b_starter))
	println(part2(a_starter, b_starter))
}
