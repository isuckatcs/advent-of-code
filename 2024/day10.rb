# frozen_string_literal: true

def traverse(map, pos)
  r, c = pos

  return [[r, c]] if map[r][c] == 9

  tops = []
  [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |dr, dc|
    nr = r + dr
    nc = c + dc

    next if nr.negative? || nc.negative? || nr >= map.length || nc >= map[nr].length
    next unless map[nr][nc] == map[r][c] + 1

    tops << traverse(map, [nr, nc])
  end

  tops.flatten(1)
end

def part1(map, zeroes)
  zeroes.map { |z| traverse(map.map { |r| r.chars.map(&:to_i) }, z).uniq.count }.sum
end

def part2(map, zeroes)
  zeroes.map { |z| traverse(map.map { |r| r.chars.map(&:to_i) }, z).count }.sum
end

map = readlines(chomp: true)

zeroes = map.each_with_index.flat_map do |row, i|
  row.chars.each_with_index.filter { |c, _| c == '0' }.map { |_, j| [i, j] }
end

puts part1 map, zeroes
puts part2 map, zeroes
