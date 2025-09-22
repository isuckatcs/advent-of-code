package main

import (
	"bufio"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type Transition struct {
	Value int
	Move  int
	State string
}

func part1(state string, steps int, transitions map[string]map[int]Transition) int {
	cursor := 0
	ones := map[int]struct{}{}

	for range steps {
		value := 0
		if _, found := ones[cursor]; found {
			value = 1
		}

		transition := transitions[state][value]
		if transition.Value == 1 {
			ones[cursor] = struct{}{}
		} else {
			delete(ones, cursor)
		}

		cursor += transition.Move
		state = transition.State
	}

	return len(ones)
}

func part2() int {
	return 0
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	lines := []string{}
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	text := strings.Join(lines, "\n")

	header_re := regexp.MustCompile(`Begin in state (\w+).
Perform a diagnostic checksum after (\d+) steps.`)

	state_re := regexp.MustCompile(`In state (\w+):
  If the current value is (\d+):
    - Write the value (\d+).
    - Move one slot to the (\w+).
    - Continue with state (\w+).
  If the current value is (\d+):
    - Write the value (\d+).
    - Move one slot to the (\w+).
    - Continue with state (\w+).`)

	header_matches := header_re.FindAllStringSubmatch(text, -1)[0]
	state_matches := state_re.FindAllStringSubmatch(text, -1)

	begin_state := header_matches[1]
	steps, _ := strconv.Atoi(header_matches[2])
	transitions := map[string]map[int]Transition{}

	for _, state_match := range state_matches {
		state := state_match[1]
		if transitions[state] == nil {
			transitions[state] = make(map[int]Transition)
		}

		for i := range 2 {
			idx := 2 + i*4
			current_value, _ := strconv.Atoi(state_match[idx])
			write_value, _ := strconv.Atoi(state_match[idx+1])

			var move int
			if state_match[idx+2] == "right" {
				move = 1
			} else {
				move = -1
			}

			next_state := state_match[idx+3]
			transitions[state][current_value] = Transition{Value: write_value, Move: move, State: next_state}
		}

	}

	println(part1(begin_state, steps, transitions))
	println(part2())
}
