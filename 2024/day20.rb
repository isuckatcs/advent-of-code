# frozen_string_literal: true

def get_path(grid, pos)
  visited = {}
  path = [pos]

  loop do
    r, c = path.last
    visited[[r, c]] = true

    break if grid[r][c] == 'E'

    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dr, dc|
      nr = r + dr
      nc = c + dc

      next if grid[nr][nc] == '#' || visited[[nr, nc]]

      path << [nr, nc]
    end
  end

  path.each_with_index.map { |p, i| [p, path.length - i - 1] }.to_h
end

def solve(grid, cheat_duration)
  start = grid.each_with_index.map { |row, i| [i, row.chars.find_index('S')] }.filter { |_, c| c }.flatten
  time_saves = Hash.new { |h, k| h[k] = 0 }

  path = get_path grid, start
  path.each_key do |pos|
    q = [[pos, 0]]
    visited = {}

    until q.empty?
      p, d = q.shift

      next if visited[p] || d > cheat_duration

      visited[p] = true
      time_saves[(path[p] - path[pos]).abs - d] += 1 if path.include? p

      [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dr, dc|
        nr = p[0] + dr
        nc = p[1] + dc

        next if nr.negative? || nc.negative? || nr >= grid.length || nc >= grid[0].length

        q << [[nr, nc], d + 1]
      end
    end
  end

  time_saves.filter_map { |k, v| v / 2 if k >= 100 }.sum
end

def part1(grid)
  solve grid, 2
end

def part2(grid)
  solve grid, 20
end

grid = readlines(chomp: true)

puts part1 grid
puts part2 grid
