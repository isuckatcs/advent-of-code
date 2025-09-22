package main

import (
	"bufio"
	"os"
	"strconv"
	"strings"
)

type Port struct {
	Lhs int
	Rhs int
}

func solve_impl(port int, visited map[int]struct{}, ports []Port, lhs_used bool, longest_only bool) (int, int) {
	if _, found := visited[port]; found {
		return 0, 0
	}

	visited[port] = struct{}{}

	src := ports[port]
	src_val := src.Lhs + src.Rhs

	max_tail_length, max_tail_strength := 0, 0
	for i := range len(ports) {
		if _, found := visited[i]; found {
			continue
		}

		dst := ports[i]

		var socket int
		if lhs_used {
			socket = src.Rhs
		} else {
			socket = src.Lhs
		}

		if socket != dst.Lhs && socket != dst.Rhs {
			continue
		}

		tail_strength, tail_length := solve_impl(i, visited, ports, socket == dst.Lhs, longest_only)

		if (!longest_only && tail_strength > max_tail_strength) || (longest_only && tail_length >= max_tail_length) {
			max_tail_length = tail_length
			max_tail_strength = tail_strength
		}
	}

	delete(visited, port)
	return src_val + max_tail_strength, 1 + max_tail_length
}

func solve(ports []Port, longest_only bool) int {
	max_strength, max_length := 0, 0

	for i, p := range ports {
		if p.Lhs == 0 || p.Rhs == 0 {
			strength, length := solve_impl(i, map[int]struct{}{}, ports, p.Lhs == 0, longest_only)

			if (!longest_only && strength > max_strength) || (longest_only && length >= max_length) {
				max_strength = strength
				max_length = length
			}
		}
	}

	return max_strength
}

func part1(ports []Port) int {
	return solve(ports, false)
}

func part2(ports []Port) int {
	return solve(ports, true)
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	ports := []Port{}
	for scanner.Scan() {
		split := strings.Split(scanner.Text(), "/")
		fst, _ := strconv.Atoi(split[0])
		snd, _ := strconv.Atoi(split[1])

		ports = append(ports, Port{fst, snd})
	}

	println(part1(ports))
	println(part2(ports))
}
