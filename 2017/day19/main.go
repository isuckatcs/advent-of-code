package main

import (
	"bufio"
	"os"
	"strings"
)

type Pair[T any, U any] struct {
	Fst T
	Snd U
}

func traverse(layout []string) Pair[string, int] {
	var dirs = []Pair[int, int]{{1, 0}, {-1, 0}, {0, 1}, {0, -1}}

	steps := 0
	out := ""

	dir := dirs[0]
	pos := Pair[int, int]{0, strings.IndexRune(layout[0], '|')}

	for {
		r, c := pos.Fst, pos.Snd
		ch := layout[r][c]

		if ch == ' ' {
			break
		}

		if 'A' <= ch && ch <= 'Z' {
			out += string(ch)
		}

		if ch == '+' {
			for _, new_dir := range dirs {
				if new_dir.Fst == -dir.Fst && new_dir.Snd == -dir.Snd {
					continue
				}

				dr, dc := pos.Fst+new_dir.Fst, pos.Snd+new_dir.Snd

				if dr >= 0 && dr < len(layout) &&
					dc >= 0 && dc < len(layout[dr]) &&
					layout[dr][dc] != ' ' {
					dir = new_dir
					break
				}
			}
		}

		steps++
		pos = Pair[int, int]{r + dir.Fst, c + dir.Snd}
	}

	return Pair[string, int]{out, steps}
}

func part1(layout []string) string {
	return traverse(layout).Fst
}

func part2(layout []string) int {
	return traverse(layout).Snd
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	layout := []string{}
	for scanner.Scan() {
		layout = append(layout, scanner.Text())
	}

	println(part1(layout))
	println(part2(layout))
}
