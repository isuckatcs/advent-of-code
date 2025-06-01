package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

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

func part1(input string) int {
	var lengths []int
	for n := range strings.SplitSeq(input, ",") {
		num, _ := strconv.Atoi(n)
		lengths = append(lengths, num)
	}

	h, _, _ := hash(default_hash_input(), 0, 0, lengths)
	return h[0] * h[1]
}

func part2(input string) string {
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

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	input := scanner.Text()

	println(part1(input))
	println(part2(input))
}
