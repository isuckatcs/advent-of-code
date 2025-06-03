package main

import (
	"bufio"
	"os"
	"strings"
)

func part1(input []string) int {
	nw, n, ne, sw, s, se := 0, 0, 0, 0, 0, 0

	for _, dir := range input {
		switch dir {
		case "nw":
			nw += 1
		case "n":
			n += 1
		case "ne":
			ne += 1
		case "sw":
			sw += 1
		case "s":
			s += 1
		case "se":
			se += 1
		}
	}

	acc, changed := nw+n+ne+sw+s+se, true
	for changed {
		// sw + se = s
		x := min(sw, se)
		sw, se, s = sw-x, se-x, s+x

		// nw + ne = n
		x = min(nw, ne)
		nw, ne, n = nw-x, ne-x, n+x

		// nw + se = 0
		x = min(nw, se)
		nw, se = nw-x, se-x

		// ne + sw = 0
		x = min(ne, sw)
		ne, sw = ne-x, sw-x

		// n + s = 0
		x = min(n, s)
		n, s = n-x, s-x

		// ne + s = se
		x = min(ne, s)
		ne, s, se = ne-x, s-x, se+x

		// nw + s = sw
		x = min(nw, s)
		nw, s, sw = nw-x, s-x, sw+x

		// se + n = ne
		x = min(se, n)
		se, n, ne = se-x, n-x, ne+x

		// sw + n = nw
		x = min(sw, n)
		sw, n, nw = sw-x, n-x, nw+x

		new_acc := nw + n + ne + sw + s + se
		acc, changed = new_acc, new_acc < acc
	}

	return acc
}

func part2(input []string) int {
	max_dist := 0
	for i := range len(input) {
		max_dist = max(max_dist, part1(input[0:i]))
	}
	return max_dist
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	dirs := strings.Split(scanner.Text(), ",")

	println(part1(dirs))
	println(part2(dirs))
}
