package main

import (
	"bufio"
	"os"
	"reflect"
	"regexp"
	"strconv"
	"strings"
)

func part1(lines [][]string) string {
	set := make(map[string]bool)

	for _, l := range lines {
		set[l[0]] = true
	}

	for _, l := range lines {
		for n := range strings.SplitSeq(l[2], ", ") {
			delete(set, n)
		}
	}

	return reflect.ValueOf(set).MapKeys()[0].String()
}

func part2(lines [][]string) int {
	weights := make(map[string]int)
	children := make(map[string][]string)

	for _, l := range lines {
		w, _ := strconv.Atoi(l[1])
		weights[l[0]] = w
		children[l[0]] = strings.Split(l[2], ", ")
	}

	s := []string{part1(lines)}
	diff := 0

	for len(s) != 0 {
		top := s[0]
		s = s[1:]

		ws := []int{}
		for _, child := range children[top] {
			w := 0
			s := []string{child}

			for len(s) != 0 {
				cur := s[0]
				s = s[1:]

				w += weights[cur]
				s = append(s, children[cur]...)
			}

			ws = append(ws, w)
		}

		unbalanced := 0
		for i := range ws {
			if ws[i] > ws[unbalanced] {
				unbalanced = i
				break
			}
		}

		if ws[unbalanced] == ws[(unbalanced+1)%len(ws)] {
			return weights[top] - diff
		}

		diff = ws[unbalanced] - ws[(unbalanced+1)%len(ws)]
		s = append(s, children[top][unbalanced])
	}

	return 0
}

func main() {
	re := regexp.MustCompile(`([a-z]+).*\((\d+)(.*-> (.*))?`)

	lines := [][]string{}
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		match := re.FindStringSubmatch(scanner.Text())
		lines = append(lines, []string{match[1], match[2], match[4]})
	}

	println(part1(lines))
	println(part2(lines))
}
