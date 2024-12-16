# frozen_string_literal: true

def solve(grid, best_tiles = [])
  start = grid.each_with_index.map { |row, i| [i, row.chars.find_index('S')] }.filter { |_, c| c }.flatten

  visited = {}
  q = [[[start], [0, 1], 0]]

  until q.empty?
    q.sort_by! { |_, _, d| d }
    path, dir, dist = q.shift
    cur = path.last

    return [dist, path, best_tiles.uniq] if grid[cur[0]][cur[1]] == 'E'

    if visited[cur]
      best_tiles += path if best_tiles.include? path.last
      next
    end

    visited[cur] = dist

    [dir, [-dir[1], dir[0]], [dir[1], -dir[0]]].each do |dr, dc|
      nr = cur[0] + dr
      nc = cur[1] + dc

      next if grid[nr][nc] == '#'

      q << [path + [[nr, nc]], [dr, dc], dist + (dir == [dr, dc] ? 1 : 1001)]
    end
  end
end

def part1(grid)
  solve(grid)[0]
end

def part2(grid)
  solve(grid, solve(grid)[1])[2].length
end

grid = readlines(chomp: true)

puts part1 grid
puts part2 grid
