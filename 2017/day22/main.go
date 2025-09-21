package main

import (
	"bufio"
	"os"
)

type Pair struct {
	Fst int
	Snd int
}

func part1(pos Pair, dir Pair, infected map[Pair]struct{}) int {
	cnt := 0
	for range 10000 {
		if _, found := infected[pos]; found {
			dir = Pair{dir.Snd, -dir.Fst}
			delete(infected, pos)
		} else {
			dir = Pair{-dir.Snd, dir.Fst}
			infected[pos] = struct{}{}
			cnt++
		}

		pos = Pair{pos.Fst + dir.Fst, pos.Snd + dir.Snd}
	}

	return cnt
}

func part2(pos Pair, dir Pair, infected map[Pair]struct{}) int {
	weakened := map[Pair]struct{}{}
	flagged := map[Pair]struct{}{}

	cnt := 0
	for range 10000000 {
		if _, found := infected[pos]; found {
			dir = Pair{dir.Snd, -dir.Fst}
			delete(infected, pos)
			flagged[pos] = struct{}{}
		} else if _, found := weakened[pos]; found {
			delete(weakened, pos)
			infected[pos] = struct{}{}
			cnt++
		} else if _, found := flagged[pos]; found {
			dir = Pair{-dir.Fst, -dir.Snd}
			delete(flagged, pos)
		} else {
			dir = Pair{-dir.Snd, dir.Fst}
			weakened[pos] = struct{}{}
		}

		pos = Pair{pos.Fst + dir.Fst, pos.Snd + dir.Snd}
	}

	return cnt
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	lines := []string{}
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	infected := map[Pair]struct{}{}
	for r := range lines {
		for c := range lines[r] {
			if lines[r][c] == '#' {
				infected[Pair{r, c}] = struct{}{}
			}
		}
	}

	infected_p2 := map[Pair]struct{}{}
	for k, v := range infected {
		infected_p2[k] = v
	}

	pos := Pair{len(lines) / 2, len(lines[0]) / 2}
	dir := Pair{-1, 0}

	println(part1(pos, dir, infected))
	println(part2(pos, dir, infected_p2))
}
