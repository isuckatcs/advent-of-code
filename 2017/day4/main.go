package main

import (
	"bufio"
	"os"
	"sort"
	"strings"
)

func part1(input [][]string) int {
	cnt := 0

	for _, words := range input {
		set := make(map[string]bool)

		for _, word := range words {
			set[word] = true
		}

		if len(set) == len(words) {
			cnt += 1
		}
	}

	return cnt
}

func part2(input [][]string) int {
	cnt := 0

	for _, words := range input {
		set := make(map[string]bool)

		for _, word := range words {
			s := strings.Split(word, "")
			sort.Strings(s)
			set[strings.Join(s, "")] = true
		}

		if len(set) == len(words) {
			cnt += 1
		}
	}

	return cnt
}

func main() {
	var input [][]string

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		input = append(input, strings.Fields(scanner.Text()))
	}

	println(part1(input))
	println(part2(input))
}
