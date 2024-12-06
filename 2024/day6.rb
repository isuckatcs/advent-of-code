# frozen_string_literal: true

require 'set'

def part1(map, guard_pos)
  dir = [-1, 0]
  oob = proc { |r, c| r.negative? || c.negative? || r >= map.size || c >= map[0].size }
  loop_desc = [[0, 0], 0]
  visited = Set[]

  loop do
    !visited.include?(guard_pos) ? loop_desc = [guard_pos, 1] : loop_desc[1] += 1
    return nil if loop_desc[1] > 1 && loop_desc[0] == guard_pos

    visited << guard_pos

    nr, nc = [guard_pos, dir].transpose.map(&:sum)
    break if oob.call(nr, nc)

    (0..3).each do |_|
      break if map[nr][nc] != '#'

      dir = [dir[1], -dir[0]]
      nr, nc = [guard_pos, dir].transpose.map(&:sum)
    end

    guard_pos = [nr, nc]
  end

  visited.length
end

def part2(map, guard_pos)
  cnt = 0
  (0...map.size).each do |i|
    (0...map[0].size).each do |j|
      next if map[i][j] != '.'

      map[i][j] = '#'
      cnt += 1 unless part1 map, guard_pos
      map[i][j] = '.'
    end
  end
  cnt
end

map = readlines(chomp: true).map(&:chars)
guard_pos = map.each_with_index.filter_map { |e, r| (c = e.index('^')) ? [r, c] : nil }.flatten

puts part1 map, guard_pos
puts part2 map, guard_pos
