# frozen_string_literal: true

require 'set'

def part1(bytes, max_coords, fallen_bytes)
  w, h = max_coords
  fallen = bytes.first(fallen_bytes).to_set

  q = [[0, 0, 0]]
  visited = Set.new

  until q.empty?
    x, y, d = q.shift

    return d if x == w && y == h
    next if visited.include?([x, y])

    visited << [x, y]

    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dx, dy|
      nx = x + dx
      ny = y + dy

      next if nx.negative? || ny.negative? || nx > w || ny > h || fallen.include?([nx, ny])

      q << [nx, ny, d + 1]
    end
  end

  0
end

def part2(bytes, max_coords)
  bytes[(0...bytes.length).find { |i| part1(bytes, max_coords, i).zero? } - 1].join(',')
end

bytes = readlines(chomp: true).map { |l| l.split(',').map(&:to_i) }

puts part1 bytes, [70, 70], 1024
puts part2 bytes, [70, 70]
