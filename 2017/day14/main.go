package main

import (
	"container/list"
	"fmt"
	"slices"
	"strconv"
)

// ==========================================
// Copied from day10/main.go
// ==========================================
func default_hash_input() []int {
	arr := make([]int, 256)
	for i := range len(arr) {
		arr[i] = i
	}
	return arr
}

func hash(input []int, current_position int, skip_size int, lengths []int) ([]int, int, int) {
	input = append(input[current_position:], input[:current_position]...)

	for _, l := range lengths {
		slices.Reverse(input[:l])
		input = append(input[l:], input[:l]...)
		input = append(input[skip_size:], input[:skip_size]...)

		current_position = (current_position + l + skip_size) % len(input)
		skip_size = (skip_size + 1) % len(input)
	}

	idx := (len(input) - current_position) % len(input)
	return append(input[idx:], input[:idx]...), current_position, skip_size
}

func knot_hash(input string) string {
	var lengths []int
	for _, c := range input {
		lengths = append(lengths, int(c))
	}
	lengths = append(lengths, []int{17, 31, 73, 47, 23}...)

	arr, t, s := default_hash_input(), 0, 0

	for range 64 {
		arr, t, s = hash(arr, t, s, lengths)
	}

	var hexString string
	for i := range 16 {
		xor := 0
		for _, n := range arr[i*16 : (i+1)*16] {
			xor ^= n
		}
		hexString += fmt.Sprintf("%02x", xor)
	}

	return hexString
}

// ==========================================

const grid_size = 128

func create_grid(key string) [grid_size][grid_size]bool {
	var grid [grid_size][grid_size]bool

	for row := range grid_size {
		hash_input := fmt.Sprintf("%s-%d", key, row)

		binary := ""
		for _, digit := range knot_hash(hash_input) {
			n, _ := strconv.ParseUint(string(digit), 16, 4)
			binary += fmt.Sprintf("%04b", n)
		}

		for col, bit := range binary {
			if bit == '1' {
				grid[row][col] = true
			}
		}
	}

	return grid
}

func part1(key string) int {
	grid := create_grid(key)

	count := 0
	for row := range grid_size {
		for col := range grid_size {
			if grid[row][col] {
				count += 1
			}
		}
	}

	return count
}

type Pos struct {
	Row int
	Col int
}

func part2(key string) int {
	grid := create_grid(key)

	groups := 0
	q := list.New()
	var visited [grid_size][grid_size]bool

	for row := range grid_size {
		for col := range grid_size {
			traversed := false
			q.PushBack(Pos{row, col})

			for q.Len() != 0 {
				p := q.Remove(q.Front()).(Pos)

				if !grid[p.Row][p.Col] || visited[p.Row][p.Col] {
					continue
				}

				traversed = true
				visited[p.Row][p.Col] = true

				for _, dir := range [4]Pos{{-1, 0}, {1, 0}, {0, 1}, {0, -1}} {
					dr := p.Row + dir.Row
					dc := p.Col + dir.Col

					if dr < 0 || dr >= grid_size || dc < 0 || dc >= grid_size {
						continue
					}

					q.PushBack(Pos{dr, dc})
				}
			}

			if traversed {
				groups++
			}
		}
	}

	return groups
}

func main() {
	var input string
	fmt.Scanln(&input)

	println(part1(input))
	println(part2(input))
}
