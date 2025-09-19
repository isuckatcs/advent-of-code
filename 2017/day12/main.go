package main

import (
	"bufio"
	"container/list"
	"os"
	"strconv"
	"strings"
)

func bfs(edges map[int][]int, visited map[int]struct{}, start int) bool {
	traversed := false
	q := list.New()
	q.PushBack(start)

	for q.Len() != 0 {
		front := q.Front()
		node := q.Remove(front).(int)

		if _, b := visited[node]; b {
			continue
		}

		visited[node] = struct{}{}
		for _, neighbour := range edges[node] {
			q.PushBack(neighbour)
		}

		traversed = true
	}

	return traversed
}

func part1(input map[int][]int) int {
	visited := make(map[int]struct{})
	bfs(input, visited, 0)
	return len(visited)
}

func part2(input map[int][]int) int {
	groups := 0
	visited := make(map[int]struct{})

	for id := range input {
		if bfs(input, visited, id) {
			groups += 1
		}
	}

	return groups
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	input := make(map[int][]int)
	for scanner.Scan() {
		split := strings.Split(scanner.Text(), " <-> ")
		id, _ := strconv.Atoi(split[0])

		pipes := make([]int, 0)
		for p := range strings.SplitSeq(split[1], ", ") {
			pipe, _ := strconv.Atoi(p)
			pipes = append(pipes, pipe)
		}

		input[id] = pipes
	}

	println(part1(input))
	println(part2(input))
}
