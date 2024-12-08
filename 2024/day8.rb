# frozen_string_literal: true

def get_antinodes(a1, a2, range)
  swap a1, a2 if a2[0] < a1[0]

  vx = a2[0] - a1[0]
  vy = a2[1] - a1[1]

  range.flat_map { |i| [[a2[0] + i * vx, a2[1] + i * vy], [a1[0] - i * vx, a1[1] - i * vy]] }
end

def solve(antennas, grid_dimensions, range)
  pairs = antennas.each_value.flat_map { |v| v.each_with_index.flat_map { |c, i| v.drop(i + 1).map { |c2| [c, c2] } } }
  antinodes = pairs.map { |a1, a2| get_antinodes a1, a2, range }.flatten(1).filter do |r, c|
    !r.negative? && r < grid_dimensions[0] && !c.negative? && c < grid_dimensions[1]
  end

  antinodes.uniq.length
end

def part1(antennas, grid_dimensions)
  solve antennas, grid_dimensions, (1..1)
end

def part2(antennas, grid_dimensions)
  solve antennas, grid_dimensions, (0..grid_dimensions[0])
end


grid = readlines(chomp: true)
grid_dimensions = [grid.length, grid[0].length]

points_of_interest = grid.each_with_index.flat_map do |row, i|
  row.chars.each_with_index.filter { |c, _| c != '.' }.map { |c, j| [c, i, j] }
end

antennas = Hash.new { |hash, key| hash[key] = [] }
points_of_interest.each { |a, i, j| antennas[a] << [i, j] }

puts part1 antennas, grid_dimensions
puts part2 antennas, grid_dimensions
