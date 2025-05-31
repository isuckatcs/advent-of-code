package main

import (
	"fmt"
	"math"
)

func get_ring_info(value int) (int, int, int) {
	ring := 1
	width := 0
	highest_value_on_ring := 1

	for highest_value_on_ring < value {
		ring += 1
		width = 2*ring - 2
		highest_value_on_ring = int(math.Pow(float64(2*ring-1), 2))
	}

	return ring, width, highest_value_on_ring
}

func part1(value int) int {
	ring, width, highest_value_on_ring := get_ring_info(value)

	section := int(math.Ceil(float64(highest_value_on_ring-value) / float64(width)))
	section_middle_value := highest_value_on_ring - ((section - 1) * width) - width/2

	return ring - 1 + int(math.Abs(float64(section_middle_value-value)))
}

func part2(value int) int {
	_, width, _ := get_ring_info(value)

	matrix := make([][]int, width+3)
	for i := range width + 3 {
		matrix[i] = make([]int, width+3)
	}

	r, c := width/2+1, width/2+1
	matrix[r][c] = 1

	vr, vc := -1, 0
	c += 1

	for r <= width+1 && c <= width+1 {
		dirs := [][]int{{1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}}
		for _, d := range dirs {
			matrix[r][c] += matrix[r+d[0]][c+d[1]]
		}

		if matrix[r][c] > value {
			return matrix[r][c]
		}

		r, c = r+vr, c+vc
		if matrix[r+-vc][c+vr] == 0 {
			vr, vc = -vc, vr
		}
	}

	return -1
}

func main() {
	var input int
	fmt.Scanln(&input)

	println(part1(input))
	println(part2(input))
}
