package main

import (
	"bufio"
	"math"
	"os"
	"strings"
)

func to_grid(pattern string) [][]rune {
	parts := strings.Split(pattern, "/")
	grid := make([][]rune, len(parts))
	for i, part := range parts {
		grid[i] = []rune(part)
	}
	return grid
}

func to_pattern(grid [][]rune) string {
	rows := make([]string, len(grid))
	for i, row := range grid {
		rows[i] = string(row)
	}
	return strings.Join(rows, "/")
}

func rotate_right(pattern string) string {
	grid := to_grid(pattern)
	out_grid := make([][]rune, len(grid))
	for i := range grid {
		out_grid[i] = make([]rune, len(grid[i]))
		copy(out_grid[i], grid[i])
	}

	for r := range len(out_grid) {
		for c := range len(out_grid) {
			out_grid[r][c] = grid[len(grid)-1-c][r]
		}
	}

	return to_pattern(out_grid)
}

func flip(pattern string, horizontal bool) string {
	grid := to_grid(pattern)
	out_grid := make([][]rune, len(grid))
	for i := range grid {
		out_grid[i] = make([]rune, len(grid[i]))
		copy(out_grid[i], grid[i])
	}

	if horizontal {
		for r := range grid {
			for c := range grid[r] {
				out_grid[r][c] = grid[r][len(grid[r])-1-c]
			}
		}
	} else {
		for r := range grid {
			out_grid[r] = grid[len(grid)-1-r]
		}
	}

	return to_pattern(out_grid)
}

func split_grid(grid string, square_size int) []string {
	grid_matrix := to_grid(grid)
	squares := []string{}

	for r := 0; r < len(grid_matrix); r += square_size {
		for c := 0; c < len(grid_matrix); c += square_size {
			square := make([][]rune, square_size)
			for i := range square_size {
				square[i] = grid_matrix[r+i][c : c+square_size]
			}

			squares = append(squares, to_pattern(square))
		}
	}

	return squares
}

func solve(rules map[string]string, iterations int) int {
	grid := ".#./..#/###"

	for range iterations {

		var split_by int
		if (strings.Count(grid, "/")+1)%2 == 0 {
			split_by = 2
		} else {
			split_by = 3
		}

		squares := split_grid(grid, split_by)
		new_squares := []string{}
		for _, square := range squares {
			new_squares = append(new_squares, rules[square])
		}

		row_cnt := strings.Count(new_squares[0], "/") + 1
		buffer := make([][]rune, row_cnt)
		rows := []string{}

		for i := range new_squares {
			if i%(int(math.Sqrt(float64(len(squares))))) == 0 {
				if i != 0 {
					rows = append(rows, to_pattern(buffer))
				}

				buffer = make([][]rune, row_cnt)
				for j := range row_cnt {
					buffer[j] = []rune{}
				}
			}

			grid_matrix := to_grid(new_squares[i])
			for k, row := range grid_matrix {
				buffer[k] = append(buffer[k], row...)
			}
		}
		rows = append(rows, to_pattern(buffer))
		grid = strings.Join(rows, "/")
	}

	return strings.Count(grid, "#")
}

func part1(rules map[string]string) int {
	return solve(rules, 5)
}

func part2(rules map[string]string) int {
	return solve(rules, 18)
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	rules := map[string]string{}

	for scanner.Scan() {
		line := scanner.Text()
		split := strings.Split(line, " => ")

		pattern := split[0]
		for range 4 {
			rules[pattern] = split[1]
			rules[flip(pattern, true)] = split[1]
			rules[flip(pattern, false)] = split[1]
			pattern = rotate_right(pattern)
		}

	}

	println(part1(rules))
	println(part2(rules))
}
