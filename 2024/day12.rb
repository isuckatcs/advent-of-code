# frozen_string_literal: true

def solve(grid)
  visited = {}

  (0...grid.length).to_a.product((0...grid[0].length).to_a).filter_map do |i, j|
    next if visited[[i, j]]

    area = 0
    perimeter = []

    q = [[i, j]]
    until q.empty?
      r, c = q.shift

      next if visited[[r, c]]

      visited[[r, c]] = true
      area += 1

      [[1, 0], [-1, 0], [0, -1], [0, 1]].each do |vr, vc|
        nr = r + vr
        nc = c + vc

        if nr.negative? || nr >= grid.length || nc.negative? || nc >= grid[0].length || grid[nr][nc] != grid[i][j]
          perimeter << [nr, nc, grid[i][j], [vr, vc]]
          next
        end

        q << [nr, nc]
      end
    end

    [area, perimeter]
  end
end

def part1(grid)
  solve(grid).map { |area, perimeter| area * perimeter.length }.sum
end

def fence_lines(perimeter)
  visited = {}

  perimeter.count do |p|
    next false if visited[p]

    q = [p]
    until q.empty?
      p = q.shift

      next if visited[p]

      visited[p] = true

      [[1, 0], [-1, 0], [0, -1], [0, 1]].each do |vr, vc|
        next if p[3][0].zero? == vr.zero?

        np = p.dup
        np[0] += vr
        np[1] += vc

        q << np if perimeter.include? np
      end
    end

    true
  end
end

def part2(grid)
  solve(grid).sum { |area, perimeter| area * fence_lines(perimeter) }
end

grid = readlines(chomp: true).map(&:chars)

puts part1 grid
puts part2 grid
