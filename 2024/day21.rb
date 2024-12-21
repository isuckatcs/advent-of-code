# frozen_string_literal: true

def sequences_to_button(pos, button, keypad)
  q = [[pos, [], []]]

  sequences = []
  until q.empty?
    pos, visited, path = q.shift

    if keypad[pos[0]][pos[1]] == button
      sequences << [pos, path + ['A']]
      next
    end

    [[-1, 0, '^'], [1, 0, 'v'], [0, 1, '>'], [0, -1, '<']].filter_map do |dr, dc, dir|
      nr = pos[0] + dr
      nc = pos[1] + dc

      next if nr.negative? || nc.negative? || nr >= keypad.length || nc >= keypad[0].length || keypad[nr][nc] == '#'
      next if visited.include? [nr, nc]

      q << [[nr, nc], [pos] + visited, path + [dir]]
    end
  end

  sequences
end

def shortest_sequences_for_pattern(pattern, start, keypad)
  shortest_sequences = []

  q = [[start, 0, []]]
  until q.empty?
    pos, idx, moves = q.shift

    if idx == pattern.length
      shortest_sequences << moves.join
      next
    end

    shortest_paths_to_cur_btn = sequences_to_button(pos, pattern[idx], keypad).group_by { |_, m| m.length }.min[1]
    shortest_paths_to_cur_btn.each { |p, path| q << [p, idx + 1, moves + path] }
  end

  shortest_sequences
end

def shortest_numeric_keypad_sequences(code)
  keypad = [
    %w[7 8 9],
    %w[4 5 6],
    %w[1 2 3],
    %w[# 0 A]
  ]

  shortest_sequences_for_pattern(code, [3, 2], keypad)
end

def shortest_directional_keypad_sequences(sequence)
  keypad = [
    %w[# ^ A],
    %w[< v >]
  ]

  shortest_sequences_for_pattern(sequence, [0, 2], keypad)
end

def expand_sequence_depth_first(move, limit, cache, depth = 0)
  return move.length if depth == limit
  return cache[[move, depth]] if cache.include? [move, depth]

  parts = move.length == 1 ? [move] : move.split('A').map { |p| "#{p}A" }

  parts = parts.map do |part|
    moves = shortest_directional_keypad_sequences(part)
    moves.map { |m| expand_sequence_depth_first(m, limit, cache, depth + 1) }.min
  end

  cache[[move, depth]] = parts.sum
  cache[[move, depth]]
end

def min_sequence_length(code, robots)
  cache = {}
  shortest_numeric_keypad_sequences(code).map { |m| expand_sequence_depth_first(m, robots, cache) }.min
end

def part1(codes)
  codes.map { |c| min_sequence_length(c, 2) * c[0..2].to_i }.sum
end

def part2(codes)
  codes.map { |c| min_sequence_length(c, 25) * c[0..2].to_i }.sum
end

codes = readlines(chomp: true)

puts part1 codes
puts part2 codes
